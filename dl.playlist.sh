#! /bin/bash
echo 0 > count
busy() { ls -f | fgrep .json | wc -l; }
# busy() { echo -n *.json | sed -e "s/*.json//" | wc -w; }
# busy() { echo -n $(( $(ps -C yt-dlp | wc -l) - 1 )) }
yt-dlp "https://music.youtube.com/playlist?list=$1" --flat-playlist --get-id | \
while read id; do
  expr $(cat count) + 1 > count
  echo "$id" >> list
  while [ $(busy) -ge 42 ]; do
    echo "maxloop"
    sleep 60
  done
  echo -n "$(cat count):$id"
  if [ -z "$(find . -name "*-$id.opus")" ]; then
    echo "..."
    find . -name "$id.*p??" -delete
    bash ../dl.single.sh "$id" "$([ -n "$2" ] && cat count)" &> "../logs/$id.log" &
  else
    echo " already exists in directory"
  fi
done

echo "loop ($(busy) left)"
while [ $(busy) -gt 0 ]; do
  sleep 10
  echo "loop ($(busy) left)"
done
echo unloop
