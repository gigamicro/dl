#!/bin/sh
scriptdir=~/dl
basedir=~/Music/dl
mkdir "$basedir" 2> /dev/null
mkdir "/tmp/dl" "/tmp/dl/link" "/tmp/dl/log" 2> /dev/null
# shellcheck disable=SC2046 disable=SC2166 disable=SC2094

while read -r listurl; do  if [ -z "$listurl" ]; then break; fi; (
  yt-dlp --version || echo "$PATH"
  if [ -f "$listurl" ]; then
    name="$(echo "$listurl" | sed 's/^.*\///; s/\..*$//')"
    coverflag=y && echo "Singlet covers - special case 1"
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
      s/^awfuless presents$//;
      ')"
    if [ -z "$name" -o "$name" = 'NA' ]; then
      echo 'getting channel'
      coverflag=y; echo "Singlet covers"
      name="$(yt-dlp "$listurl" --flat-playlist --print channel | sort | uniq -c | sort -nr | head -n 1 | tail -c +9 | sed '
        s/ - Topic$//;
        s/\W*official channel$//;
        ')"
    fi
    [ "$name" = 'ENA' ] && coverflag=y && echo "Singlet covers - special case 2"
  fi
  [ -z "$name" -o "$name" = 'NA' ] && echo 'invalid playlist name' && exit
  dir="$basedir/$name"
  echo "$listurl -> $dir."
  ln -svrT "/tmp/dl/log/${listurl##*/}.log" "/tmp/dl/link/$name.log"
  mkdir -v "$dir" 2> /dev/null || echo "Directory exists"
  cd "$dir" || exit

  rm -v ./*.mp4 ./*.webp ./*.part ./*.jpg 2> /dev/null && echo "Deleted remains"
  find . -maxdepth 1 | sed 's/.*\[/youtube /;s/\].[.a-z0-9]*//' > "$dir/$name.archive"
  cat "$scriptdir/ignore/$name.archive" >> "$dir/$name.archive" 2>/dev/null && echo "Added ignore to archive"
  sed 's/youtube //' < "$scriptdir/ignore/$name.archive" 2>/dev/null | while read -r id; do rm -v ./*"[$id]"* 2>/dev/null; done

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
  if [ ! "$coverflag" != "y" ]; then echo "No downloaded cover (coverflag set)"
  elif [ -f "$dir/cover.png" ]; then echo "No downloaded cover (cover exists)"
  elif [ -f "$listurl" ];       then echo "No downloaded cover (local playlist)"
  else
    echo "Auto cover"
    yt-dlp "$listurl" \
    --write-thumbnail --skip-download --max-downloads 1 -o 'cover'
    ffmpeg -i cover.* cover.webp
    sh "$scriptdir/square.sh" "cover.webp"
    ffmpeg -i "cover.webp" cover.png
    rm "cover.webp"
    echo "No downloaded cover "
  fi

  echo "Writing playlist"
  true > "./$name.m3u"
  (if [ -f "$listurl" ]; then
    sed 's/^https:\/\/youtu.be\///' <"$listurl"
  else
    yt-dlp "$listurl" --flat-playlist --print id
  fi) | while read -r id; do echo ./*"$id"* >> "./$name.m3u"; done

  rm "$dir/$name.archive"

  date +"├────────────────┤ done at %FT%T ├────────────────┤"
  ) >"/tmp/dl/log/${listurl##*/}.log" 2>&1 &
done < "$scriptdir/playlists.m3u"
# date +"complete at %FT%T"
echo "sure thing boss"
