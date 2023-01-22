#!/bin/sh
scriptdir=~/dl
basedir=~/Music/dl
mkdir "$basedir" 2> /dev/null

while read line; do  if [ -z "$line" ]; then break; fi; (
  # cd "$basedir"
  listid="${line%% *}"
  name="${line#$listid }"
  dir="$basedir/$name"
  echo "$listid -> $dir."
  mkdir "$dir" 2> /dev/null || echo "Directory exists"
  cd "$dir" || exit
  if [ -e "$scriptdir/covers/$name" ]; then
    coverflag=y
    echo "Singlet covers"
  else
    coverflag=n
    echo "Coverflag set"
  fi

  rm *.mp4 *.webp *.part *.jpg 2> /dev/null && echo "Deleted remains"
  ls | sed 's/.*\[/youtube /;s/\].[.a-z0-9]*//' > "$basedir/$name/$name.archive"
  cat "$scriptdir/ignore/$name.archive" >> "$basedir/$name/$name.archive" 2>/dev/null && echo "Added ignore to archive"
  cat "$scriptdir/ignore/$name.archive" 2>/dev/null | sed 's/youtube //' | while read id; do rm *"[$id]"* 2>/dev/null; done && echo "Deleted ignored songs"

  yt-dlp --embed-metadata --format 'ba*' -x \
  $(if [ -f "$listid" ]; then
    echo --batch-file "$listid"
  else
    echo "https://music.youtube.com/playlist?list=$listid"
  fi) \
  --embed-thumbnail --exec before_dl:"'$scriptdir/square.sh' *\" [%(id)s].webp\" || '$scriptdir/square.sh' *\" [%(id)s].jpg\"" \
  --no-overwrites --download-archive "$basedir/$name/$name.archive" \
  --concurrent-fragments 32 \
  $(if [ "$coverflag" = "n" ]; then
    echo "--no-embed-thumbnail --no-exec --parse-metadata playlist_index:%(track_number)s "
  fi) 

  # --print-to-file '%(title)s [%(id)s].*' "$name.m3u" \
  # --playlist-random \
  if cp -n -T "$scriptdir/covers/$name.png" "$dir/cover.png" 2> /dev/null; then
    echo "Manual cover"
  elif [ "$coverflag" = "n" -a ! -f "$dir/cover.png" ]; then
    echo "Auto cover"
    yt-dlp "https://youtube.com/playlist?list=$listid" \
    --write-thumbnail --skip-download --max-downloads 1 -o 'cover'
    sh "$scriptdir/square.sh" "cover.webp";
    ffmpeg -i "cover.webp" cover.png
    rm "cover.webp"
  else
    echo "No cover"
  fi

  echo "Writing playlist"
  > "./$name.m3u"
  (if [ -f "$listid" ]; then
    sed 's/^https:\/\/youtu.be\///' <"$listid"
  else
    yt-dlp "https://youtube.com/playlist?list=$listid" --flat-playlist --print id
  fi) | while read id; do echo ./*$id* >> "./$name.m3u"; done

  rm "$basedir/$name/$name.archive"

  date +"├────────────────┤ done at %FT%T ├────────────────┤"
  ) >"/tmp/dl_${line#* }.log" 2>&1 &
done < "$scriptdir/playlists.txt"
# date +"complete at %FT%T"
echo "sure thing boss"
