#!/bin/sh
scriptdir="$(readlink -f -z "$0" | xargs -0 dirname)" # canonicalize because there is a cd later
basedir="$(cat "$scriptdir/basedir")"
rm -v /tmp/dl.wait.pids 2> /dev/null
mkdir -vp "$basedir"
rm -r "/tmp/dl/link" "/tmp/dl/log" 2> /dev/null
mkdir "/tmp/dl" "/tmp/dl/link" "/tmp/dl/log" 2> /dev/null
cd "/tmp/dl" # test canonicalization
[ -x "$scriptdir/square.sh" ] || { echo err: square.sh missing; exit 1; }
[ -x "$scriptdir/nametoignores.sh" ] || { echo err: nametoignores.sh missing; exit 1; }
[ -d "$scriptdir/ignore" ] || echo no ignores

# shellcheck disable=SC2046 disable=SC2166 disable=SC2094
for listing in "playlists" "artists" "albums"; do
grep -v '^[;#]' "$scriptdir/$listing.m3u" | \
while read -r listurl; do  if [ -z "$listurl" ]; then break; fi; logloc="/tmp/dl/log/${listurl##*/}.log"; {
  case $listing in
    playlists|artists) coverflag=individual ;;
    albums) coverflag=group ;;
    *) echo "big error, unrecognised \$listing";;
  esac
  if [ -f "$listurl" ]; then
    echo "file playlist"
    name="$(basename "$listurl" .m3u)"
  else
    case $listing in
    artists)
      echo 'artist'
      if   [ "${listurl#*youtube.com/@}" != "$listurl" ]; then
        listurl="${listurl%/videos}/videos"
        name="$(yt-dlp "$listurl" --playlist-end 1 --flat-playlist --print playlist_title | sed 's/ - Videos$//;ss/s⧸sg')"
      elif [ "${listurl#*soundcloud.com/}" != "$listurl" ]; then
        listurl="${listurl%/tracks}/tracks"
        name="$(yt-dlp "$listurl" --playlist-end 1 --flat-playlist --print playlist_title | sed 's/ (Tracks)$//;ss/s⧸sg')"
      elif [ "${listurl#*.bandcamp.com}" != "$listurl" ]; then
        name="$(yt-dlp "$listurl" --playlist-end 1 --flat-playlist --print playlist_title | sed 's/^Discography of //;ss/s⧸sg')"
      else
        name="$(yt-dlp "$listurl" --flat-playlist --print channel | sort | uniq -c | sort -nr | head -n 1 | tail -c +9 | sed '
          s/ - Topic$//;
          s/\W*official channel\W*$//i;
          ss/s⧸sg;
        ')"
      fi
      ;;
    playlists|albums)
      echo $listing | sed 's/s$//'
      name="$(yt-dlp "$listurl" --playlist-end 1 --flat-playlist --print playlist_title | \
        sed '
        s/^Album - //;
        s/[- (]*Vol[ume.]* / vol. /i;
        s/ *([^(]*)$//;
        s/ *\[[^[]*]$//;
        s/ *-.*$//;
        s/ *O[fficial riginal Game]*S[ound ]*T[rack]*//i;
        s/:/∶/g;
        ss/s⧸sg;
        ')"
      echo "name: $name, album: $(yt-dlp "$listurl" --print album | sort | uniq -c | sort -nr | head -n 1 | tail -c +9 )"
      ;;
    *) echo "big error, unrecognised \$listing";;
    esac
  fi
  date -Is
  if [ -z "$name" ]||[ "$name" = 'NA' ]; then
    echo 'no playlist name'
    ln -svrT "$logloc" "/tmp/dl/link/${logloc##*/}"
    exit
  fi
  dir="$basedir/$name"
  printf '%s -> %s.\n' "$listurl" "$dir"
  ln -svrT "$logloc" "/tmp/dl/link/$name.log" || ln -svrT "$logloc" "/tmp/dl/link/${logloc##*/}"
  mkdir -v "$dir"
  cd "$dir" || exit

  find . -maxdepth 1 ! -iname '*.webp' ! -iname '*.png' ! -iname '*.jpg' \
  ! -name '*.part' ! -name '*.part-Frag*' ! -name '* \[*].temp.*' ! -name '*.ytdl' ! -name '*.json' ! -empty | \
  "$scriptdir/nametoignores.sh" > "$dir/$name.archive"
  if [ -f "$scriptdir/ignore/$name.archive" ]; then
    echo "Applying ignore"
    cat "$scriptdir/ignore/$name.archive" | tee -a "$dir/$name.archive" | \
    grep -v '^;' | cut -d\  -f 2- | "$scriptdir/unpattern.sh" | xargs -d \\n -i{} find . -name '* \[{}].*' -print0 | xargs -r0 rm -v
  fi

  yt-dlp --embed-metadata --format 'ba*' -x \
  $([ -f "$listurl" ] && printf '%s' --batch-file) "$listurl" \
  --trim-filenames 255 \
  --no-overwrites --download-archive "$dir/$name.archive" \
  --concurrent-fragments 32 \
  --embed-thumbnail --exec before_dl:"find . -name '* \[%(id)s].*' -exec '$scriptdir/square.sh' {} \;" \
  $( [ "$coverflag" = group ] && printf '%s ' --no-embed-thumbnail --no-exec --parse-metadata "playlist_index:%(track_number)s") \
  --exec after_move:"printf 'success:%s\n' %(filename)q"
  #--playlist-random -i \
  #--print-to-file filename "$name.m3u" \

  if [ "$coverflag" = individual ]; then echo "No downloaded cover (coverflag unset)"
    find . -name 'cover.*' -print0 | xargs -0r rm -v
  elif [ -f "$listurl" ];           then echo "No downloaded cover (local playlist)"
    find . -name 'cover.*' -print0 | xargs -0r rm -v
  elif [ -n "$(find . -name 'cover.*' -print -quit)" ]; then echo "No downloaded cover (cover exists)"
  else
    echo "Auto cover"
    yt-dlp "$listurl" --write-thumbnail --skip-download --max-downloads 1 -o 'cover'
    find . -name 'cover.*' -print0 | xargs -0rn1 "$scriptdir/square.sh"
  fi

  echo "Writing playlist"
[ "${listurl#*.bandcamp.com}" != "$listurl" ] ||
  yt-dlp $([ -f "$listurl" ] && printf '%s' --batch-file) "$listurl" --flat-playlist --print id | \
  "$scriptdir/unpattern.sh" | xargs -d \\n -I{} -t find ./ -name '* \[{}].*' -maxdepth 1 \
  -print0 -nowarn 2>&1 | sed -z 's/[^\n]*\n\([^\n]*\)$/\1/; s/[^\n]*\n/\n/g' | tr '\0' '\n' \
  > "./$name.m3u"
  # (complex line and -t option is to have newlines at nonexistent files)

  rm "$dir/$name.archive"

  date +"├────────────────┤ done at %FT%T ├────────────────┤"
  } >"$logloc" 2>&1 &
printf '%s\n' "$!" >> /tmp/dl.wait.pids
done
done
echo "sure thing boss ($$)"
wait
while [ -n "$(
  while read -r i; do
    kill -0 "$i" 2>&- && echo || echo done
  done </tmp/dl.wait.pids |
  wc -wl | sed 's/^ *\([0-9]*\) *\([0-9]*\)$/\2\/\1/' |
  tee -a /dev/fd/2 | sed 'ss^\([0-9]*\)/\1$ss' # clear if both numbers are equal
)" ]; do sleep 2.718281828459; done 2>&1 | stdbuf -o 16 tr '\n' '\r'
rm /tmp/dl.wait.pids
echo "done boss"
