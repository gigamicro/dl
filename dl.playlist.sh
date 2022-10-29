#! /bin/bash
echo 0 > count
busy() { ls -f | fgrep .json | wc -l; }
# busy() { echo -n *.json | sed -e "s/*.json//" | wc -w; }
# busy() { echo -n $(( $(ps -C yt-dlp | wc -l) - 1 )) }
yt-dlp "https://music.youtube.com/playlist?list=$1" --flat-playlist --get-id $2 | \
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
    find . -name "$v.*p??" ! -name "*-$v.opus" -delete
    rm ../logs/**$v.*o? 2> /dev/null && echo "Deleted old log"
    bash ../dl.single.sh "$v" "$3" "$4" "$(if [ -n "$5" ]; then cat count; fi)" &> "../logs/$v.log" &
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
