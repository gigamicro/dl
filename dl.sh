#!/bin/sh
scriptdir=~/dl
basedir=~/Music/dl
mkdir "$basedir" 2> /dev/null

while read listurl; do  if [ -z "$listurl" ]; then break; fi; (
  if [ -f "$listurl" ]; then
    name="$(echo "$listurl" | sed 's/^.*\///; s/\..*$//')"
  else
    name="$(yt-dlp "$listurl" --playlist-end 1 --flat-playlist --print playlist_title | \
      sed 's/^Album - //; s/ *(.*)$//; s/ *O[fficial riginal]*S[ound ]*T[rack]*$//i;  s/ *-.*$//;   s/^NA$//; s/^[SongVideo]*s$//')"
    [ -z "$name" -o "$name" = 'NA' ] && echo 'getting artist'   && coverflag=y && echo "Singlet covers" && \
    name="$(yt-dlp "$listurl" --playlist-end 1 --flat-playlist --print artist)"
    [ -z "$name" -o "$name" = 'NA' ] && echo 'getting uploader' && \
    name="$(yt-dlp "$listurl" --playlist-end 1 --flat-playlist --print uploader | \
      sed 's/ - Topic$//')"
  fi
  [ -z "$name" -o "$name" = 'NA' ] && echo 'invalid playlist name' && exit
  dir="$basedir/$name"
  echo "$listurl -> $dir."
  mkdir -v "$dir" 2> /dev/null || echo "Directory exists"
  cd "$dir" || exit

  rm -v *.mp4 *.webp *.part *.jpg 2> /dev/null && echo "Deleted remains"
  ls | sed 's/.*\[/youtube /;s/\].[.a-z0-9]*//' > "$dir/$name.archive"
  cat "$scriptdir/ignore/$name.archive" 2>/dev/null | sed 's/youtube //' | while read id; do rm *"[$id]"* 2>/dev/null; done && echo "Deleted ignored songs"

  yt-dlp --embed-metadata --format 'ba*' -x \
  $(if [ -f "$listurl" ]; then
    echo --batch-file "$listurl"
  else
    echo "$listurl"
  fi) \
  --embed-thumbnail --exec before_dl:"'$scriptdir/square.sh' *\" [%(id)s].webp\" || '$scriptdir/square.sh' *\" [%(id)s].jpg\"" \
  --no-overwrites --download-archive "$basedir/$name/$name.archive" \
  --concurrent-fragments 32 \
  $(if [ "$coverflag" = "n" ]; then
    echo "--no-embed-thumbnail --no-exec --parse-metadata playlist_index:%(track_number)s "
  fi) 

  # --print-to-file '%(title)s [%(id)s].*' "$name.m3u" \
  # --playlist-random \
  if [ ! "$coverflag" != "y" ]; then echo "No downloaded cover (coverflag set)"
  elif [ -f "$dir/cover.png" ]; then echo "No downloaded cover (cover exists)"
  elif [ -f "$listurl" ];       then echo "No downloaded cover (local playlist)"
  else
    echo "Auto cover"
    yt-dlp "$listurl" \
    --write-thumbnail --skip-download --max-downloads 1 -o 'cover'
    sh "$scriptdir/square.sh" "cover.webp"
    ffmpeg -i "cover.webp" cover.png
    rm "cover.webp"
    echo -n "No downloaded cover "
  fi

  echo "Writing playlist"
  > "./$name.m3u"
  (if [ -f "$listurl" ]; then
    sed 's/^https:\/\/youtu.be\///' <"$listurl"
  else
    yt-dlp "$listurl" --flat-playlist --print id
  fi) | while read id; do echo ./*$id* >> "./$name.m3u"; done

  rm "$dir/$name.archive"

  date +"├────────────────┤ done at %FT%T ├────────────────┤"
  ) >"/tmp/dl_${listurl##*/}.log" 2>&1 &
done < "$scriptdir/playlists.m3u"
# date +"complete at %FT%T"
echo "sure thing boss"
