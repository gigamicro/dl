#! /bin/bash
# rm -rf logs/dlc dlc dlc.*.err
mkdir dlc 2> /dev/null
cd dlc
mkdir ../logs/ 2> /dev/null
mkdir ../logs/dlc 2> /dev/null

cat ../dlcplaylists.txt <(echo) | \
while read i; do
  if [ -z "$i" ]; then break; fi
  locator=${i/ */}
  dir=${i/$locator /$(pwd)/}
  echo "$locator -> $dir."
  mkdir "$dir" 2> /dev/null || echo "Directory exists"
  cp -T "../drm/trims/${i/$locator /}.sh" trim.sh 2> /dev/null && echo "Trim script exists"

  bash ../dl.playlist.sh $locator " $1" " $2" " $3" y

  cp -n -T "../drm/covers/${i/$locator /}.png" "$dir/cover.png" 2> /dev/null && echo "Manual cover"
  if [ ! -f "$dir/cover.png" ]; then
    qwe=$(youtube-dl "https://music.youtube.com/playlist?list=$locator" --playlist-items 1 --get-id)
    bash ../dl.single.image.sh "$qwe"
    mv "./$qwe.png" cover.png
  fi

  # if [ -f "$dir/trim.sh" ]; then true; fi
  rm trim.sh 2> /dev/null
  mv ./cover.png ./*.opus "$dir" 2> /dev/null || echo "No downloads"
  mv -n ../logs/*.log ../logs/dlc/ 2> /dev/null || echo "No logs"
  rm ../logs/*.log 2> /dev/null || echo "No ignored logs"
  mv err "../dlc.${i/$locator /}.err" 2> /dev/null || echo "No err"

  # echo writing playlist
  # echo 0 > count
  # echo "[playlist]" > list.pls
  # echo -n "" > list.m3u
  # cat list | while read i; do
  #   expr $(cat count) + 1 > count
  #   echo "File$(cat count)=$(echo -n ./*/*$i.opus)" >> list.pls
  #   echo "$(echo -n ./*/*$i.opus)" >> list.m3u
  #   # ffmpeg -i ./*/*$i.opus -acodec copy -metadata order=$(cat count) o.opus && mv o.opus ./*/*$i.opus; rm o.opus 2> /dev/null
  # done
  # echo "NumberOfEntries=$(cat count)" >> list.pls
  # mv list.pls "${i/$locator /}.pls"
  # mv list.m3u "${i/$locator /}.m3u"
  rm list count 2> /dev/null || echo "No count"

  echo done at $(date)
done
echo complete at $(date)
cd ..
