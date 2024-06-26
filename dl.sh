#!/bin/sh
scriptdir="$(readlink -f -z "$0" | xargs -0 dirname)" # canonicalize because there is a cd later
basedir="$(cat "$scriptdir/basedir")"
rm -v /tmp/dl.wait.pids 2> /dev/null
mkdir -v "$basedir" 2> /dev/null
rm -r "/tmp/dl/link" "/tmp/dl/log" 2> /dev/null
mkdir "/tmp/dl" "/tmp/dl/link" "/tmp/dl/log" 2> /dev/null
cd "/tmp/dl" # test canonicalization
[ -x "$scriptdir/square.sh" ] || { echo err: square.sh missing; exit 1; }
[ -x "$scriptdir/nametoignores.sh" ] || { echo err: nametoignores.sh missing; exit 1; }
[ -d "$scriptdir/ignore" ] || echo no ignores

# shellcheck disable=SC2046 disable=SC2166 disable=SC2094
for listing in "playlists" "artists" "albums"; do
grep -v '^[;#]' "$scriptdir/$listing.m3u" | \
while read -r listurl; do  if [ -z "$listurl" ]; then break; fi; logloc="/tmp/dl/log/${listurl##*/}.log"; (
  # yt-dlp --version || echo "$PATH"
  case $listing in
    playlists|artists) coverflag=y ;;
    albums) coverflag=n ;;
    *) echo "big error, unrecognised \$listing";;
  esac
  if [ -f "$listurl" ]; then
    echo "file playlist"
    name="$(basename "$listurl" .m3u)"
  else
    case $listing in
    # playlists)
    #   echo 'playlist'
    #   name="$(yt-dlp "$listurl" --print album | sort | uniq -c | sort -nr | head -n 1 | tail -c +9 )"
    #   ;;
    artists)
      echo 'artist'
      if [ "${listurl#*youtube.com}" == "$listurl" ]&&
        [ "${listurl#*youtube.com/playlist}" != "$listurl" ]&&
        [ "${listurl#*youtube.com/watch}" != "$listurl" ]; then
          echo "YT channel handling"
          listurl="${listurl%/videos}/videos"
      fi
      name="$(yt-dlp "$listurl" --flat-playlist --print channel | sort | uniq -c | sort -nr | head -n 1 | tail -c +9 | sed '
        s/ - Topic$//;
        s/\W*official channel\W*$//i;
        ss/s⧸s;
        ')"
      if [ "$name" = "NA" ]; then
        if [ "${listurl#*soundcloud.com}" != "$listurl" ]; then
          name="${listurl#*soundcloud.com/}"
          name="${name%%/*}"
          listurl="${listurl%%soundcloud.com/*}soundcloud.com/$name/tracks"
        fi
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
        s/:/∶/;
        ss/s⧸s;
        ')"
      echo "name: $name, album: $(yt-dlp "$listurl" --print album | sort | uniq -c | sort -nr | head -n 1 | tail -c +9 )"
      ;;
    # albums)
    #   echo 'album'
    #   name="$(yt-dlp "$listurl" --playlist-end 1 --flat-playlist --print playlist_title | \
    #     sed '
    #     s/^Album - //;
    #     s/ *(.*)$//;
    #     s/ *O[fficial riginal]*S[ound ]*T[rack]*$//i;
    #     s/ *-.*$//;
    #     ')"
    #   ;;
    *) echo "big error, unrecognised \$listing";;
    esac
  fi
  if [ -z "$name" ]||[ "$name" = 'NA' ]; then
    echo 'invalid playlist name'
    ln -svrT "$logloc" "/tmp/dl/link/${listurl##*/}.log"
    exit
  fi
  dir="$basedir/$name"
  printf '%s -> %s.\n' "$listurl" "$dir"
  ln -svrT "$logloc" "/tmp/dl/link/$name.log"
  mkdir -v "$dir"
  cd "$dir" || exit

  # rm -v ./*.mp4 ./*.webp ./*].png ./*.part ./*.jpg ./*.temp.* 2> /dev/null && echo "Deleted remains"
  # find . -maxdepth 1 -name '*.temp*' -delete
  # find . -type f ! -name 'cover.*' -name '*.webp' -o -name '*.part' -delete

  find . -maxdepth 1 ! -iname '*.webp' ! -iname '*.png' ! -iname '*.jpg' ! -iname '*.part' ! -iname '* [*].temp.*' ! -empty | \
  "$scriptdir/nametoignores.sh" > "$dir/$name.archive"
  if [ -f "$scriptdir/ignore/$name.archive" ]; then
    echo "Applying ignore"
    cat "$scriptdir/ignore/$name.archive" | tee -a "$dir/$name.archive" | \
    grep -v '^;' | cut -d\  -f 2- | "$scriptdir/unpattern.sh" | xargs -d \\n -i{} find . -name '* \[{}].*' -print0 | xargs -0 rm -v
  fi

  yt-dlp --embed-metadata --format 'ba*' -x \
  $([ -f "$listurl" ] && printf '%s' --batch-file) "$listurl" \
  --no-overwrites --download-archive "$dir/$name.archive" \
  --concurrent-fragments 32 \
  --embed-thumbnail --exec before_dl:"find . -name '"'* \[%(id)s].*'"' -print0 | xargs -0 -n 1 '$scriptdir/square.sh'" \
  $( ! [ "$coverflag" = "y" ] && printf '%s ' --no-embed-thumbnail --no-exec --parse-metadata "playlist_index:%(track_number)s")
  #--playlist-random -i \
  #--print-to-file filename "$name.m3u" \

  if [ "$coverflag" = "y" ]; then echo "No downloaded cover (coverflag unset)"
  elif [ -n "$(find . -name 'cover.*' -quit)" ]; then echo "No downloaded cover (cover exists)"
  elif [ -f "$listurl" ];       then echo "No downloaded cover (local playlist)"
  else
    echo "Auto cover"
    find . -name 'cover.*' -print0 | xargs -0 rm -v
    yt-dlp "$listurl" --write-thumbnail --skip-download --max-downloads 1 -o 'cover'
    find . -name 'cover.*' -print0 | xargs -0 -n 1 "$scriptdir/square.sh"
  fi

  echo "Writing playlist"
  yt-dlp $([ -f "$listurl" ] && printf '%s' --batch-file) "$listurl" --flat-playlist --print id | \
  "$scriptdir/unpattern.sh" | xargs -d \\n -i{} -t find ./ -name '* \[{}].*' -maxdepth 1 \
  -print0 -nowarn 2>&1 | sed -z 's/[^\n]*\n\([^\n]*\)$/\1/; s/[^\n]*\n/\n/' | tr '\0' '\n' \
  > "./$name.m3u"
  # (complex line is to have newlines at nonexistent files)

  rm "$dir/$name.archive"

  date +"├────────────────┤ done at %FT%T ├────────────────┤"
  ) >"$logloc" 2>&1 &
printf '%s\n' "$!" >> /tmp/dl.wait.pids
done
done
# date +"complete at %FT%T"
echo "sure thing boss ($$)"
wait # (doesn't)
while read i; do
  while kill -0 "$i" 2>&-; do
    sleep 6
  done
done </tmp/dl.wait.pids
rm /tmp/dl.wait.pids
echo "done boss"
