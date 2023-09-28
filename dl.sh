#!/bin/sh
scriptdir="$(dirname "$0")"
basedir="$(cat "$scriptdir/basedir")"
mkdir "$basedir" 2> /dev/null
mkdir "/tmp/dl" "/tmp/dl/link" "/tmp/dl/log" 2> /dev/null

[ -x "$scriptdir/square.sh" ] || { echo err: square.sh missing; exit 1; }
# [ -d "$scriptdir/ignore" ] || echo no ignores

# shellcheck disable=SC2046 disable=SC2166 disable=SC2094
for listing in "playlists" "artists" "albums"; do
while read -r listurl; do  if [ -z "$listurl" ]; then break; fi; (
  yt-dlp --version || echo "$PATH"
  if [ -f "$listurl" ]; then
    name="$(echo "$listurl" | sed 's/^.*\///; s/\..*$//')"
    coverflag=y && echo "Singlet covers - file playlist"
  else
    # echo "album: $(yt-dlp "$listurl" --print album | sort | uniq -c | sort -nr | sed 's/^........//')" &
    name="$(yt-dlp "$listurl" --playlist-end 1 --flat-playlist --print playlist_title | \
      sed '
      s/^Album - //;
      s/ *(.*)$//;
      s/ *O[fficial riginal]*S[ound ]*T[rack]*$//i;
      s/ *-.*$//;
      s/^NA$//;
      s/^Songs$//;
      s/^Videos$//;
      s/^Uploads.*$//;
      s/^awfuless presents$//;
      s/.*'\''s Music$//;
      ')"
    if [ -z "$name" ]; then
      echo 'getting channel'
      coverflag=y; echo "Singlet covers"
      name="$(yt-dlp "$listurl" --flat-playlist --print channel | sort | uniq -c | sort -nr | head -n 1 | tail -c +9 | sed '
        s/ - Topic$//;
        s/\W*official channel\W*$//i;
        ')"
    fi
    [ "$name" = 'ENA' ] && coverflag=y && echo "Singlet covers - special case"
  fi
  [ -z "$name" -o "$name" = 'NA' ] && echo 'invalid playlist name' && exit
  dir="$basedir/$name"
  echo "$listurl -> $dir."
  ln -svrT "/tmp/dl/log/${listurl##*/}.log" "/tmp/dl/link/$name.log"
  mkdir -v "$dir" 2> /dev/null || echo "Directory exists"
  cd "$dir" || exit

  rm -v ./*.mp4 ./*.webp ./*].png ./*.part ./*.jpg ./*.temp.* 2> /dev/null && echo "Deleted remains"
  # find . -maxdepth 1 -name '*.temp*' -delete
  
  find . -maxdepth 1 | sed 's/^.* \[\([0-9a-zA-Z_-]\{11\}\)\].*$/youtube \1/' > "$dir/$name.archive"
  if [ -d "$scriptdir/ignore" ]; then
    cat "$scriptdir/ignore/$name.archive" >> "$dir/$name.archive" 2>/dev/null && echo "Added ignore to archive"
    sed 's/youtube //' < "$scriptdir/ignore/$name.archive" 2>/dev/null | while read -r id; do rm -v ./*"[$id]"* 2>/dev/null; done
  fi

  yt-dlp --embed-metadata --format 'ba*' -x \
  $(if [ -f "$listurl" ]; then
    echo --batch-file "$listurl"
  else
    echo "$listurl"
  fi) \
  --no-overwrites --download-archive "$dir/$name.archive" \
  --concurrent-fragments 32 \
  --embed-thumbnail --exec before_dl:"'$scriptdir/square.sh' *\" [%(id)s].webp\" || '$scriptdir/square.sh' *\" [%(id)s].jpg\"" \
  $(if [ "$coverflag" != "y" ]; then
    echo "--no-embed-thumbnail --no-exec --parse-metadata playlist_index:%(track_number)s "
  fi)

  #--playlist-random -i \
  # --print-to-file '%(title)s [%(id)s].*' "$name.m3u" \
  if [ ! "$coverflag" != "y" ]; then echo "No downloaded cover (coverflag unset)"
  elif [ -f "$dir/cover.png" ]; then echo "No downloaded cover (cover exists)"
  elif [ -f "$listurl" ];       then echo "No downloaded cover (local playlist)"
  else
    echo "Auto cover"
    yt-dlp "$listurl" \
    --write-thumbnail --skip-download --max-downloads 1 -o 'cover'
    ffmpeg -i cover.* cover.png
    sh "$scriptdir/square.sh" "cover.png"
    # echo "No downloaded cover "
  fi

  echo "Writing playlist"
  true > "./$name.m3u"
  (if [ -f "$listurl" ]; then
    sed 's/^https:\/\/youtu.be\///' <"$listurl"
  else
    yt-dlp "$listurl" --flat-playlist --print id
  fi) | while read -r id; do find ./ -maxdepth 1 -name "*\[$id].*" >> "./$name.m3u"; done

  rm "$dir/$name.archive"

  date +"├────────────────┤ done at %FT%T ├────────────────┤"
  ) >"/tmp/dl/log/${listurl##*/}.log" 2>&1 &
done < "$scriptdir/$listing.m3u"
done
# date +"complete at %FT%T"
echo "sure thing boss ($$)"
wait
echo "done boss"
