#! /bin/bash
mkdir dlc 2> /dev/null
cd dlc
mkdir ../logs/ 2> /dev/null
mkdir ../logs/dlc 2> /dev/null

cat ../dlcplaylists.txt <(echo) | \
while read line; do
  if [ -z "$line" ]; then break; fi
  listid=${line/ */}
  name=${line/$listid /}
  dir="$(pwd)/$name"
  echo "$listid -> $dir."
  mkdir "$dir" 2> /dev/null || echo "Directory exists"
  cp -T "../drm/trims/$name.sh" trim.sh 2> /dev/null && echo "Trim script exists"
  [ -e "../drm/covers/$name" ] && coverflag= && echo "Singlet covers" || coverflag=y

  bash ../dl.playlist.sh $listid $coverflag

  cp -n -T "../drm/covers/$name.png" "$dir/cover.png" 2> /dev/null && echo "Manual cover"
  if [ -z "$coverflag" -a ! -f "$dir/cover.png" ]; then
    echo "Auto cover"
    coverid=$(yt-dlp "https://music.youtube.com/playlist?list=$listid" --playlist-items 1 --get-id)
    yt-dlp "https://youtube.com/watch?v=$coverid" -o "$coverid" --skip-download --write-info-json
    mv "./$coverid.info.json" "./$coverid.json"
    bash ../dl.single.image.sh "$coverid"
    mv "./$coverid.png" cover.png
    rm "./$coverid.json"
  fi

  echo cleaning...
  mv ./*???????????.opus "$dir" 2> /dev/null || echo "No downloads"
  mv ./cover.png "$name.m3u" "$dir" 2> /dev/null || echo "No cover/list"
  mv -n ../logs/*.log ../logs/dlc/ 2> /dev/null || echo "No logs"
  mv err "../dlc.$name.err" 2> /dev/null || echo "No err"
  rm trim.sh 2> /dev/null

  echo "Writing playlist"
  cd "$dir"
  > "$name.m3u" # empty
  while read id; do
    echo ./*-$id.opus >> "$name.m3u"
  done < ../list
  cd ..
  rm list count 2> /dev/null || echo "No list/count"
  rm ../logs/*.log 2> /dev/null || echo "No ignored logs"

  date +"done at %FT%T"
done
date +"complete at %FT%T"
cd ..
