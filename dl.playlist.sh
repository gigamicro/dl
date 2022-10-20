#! /bin/bash
echo 0 > count
busy() { echo -n *.json | sed -e "s/*.json//" | wc -w; }
# busy() { echo -n $(( $(ps -C youtube-dl | wc -l) - 1 )) }
youtube-dl "https://music.youtube.com/playlist?list=$1" --match-filter "duration < 1024" --flat-playlist --get-id $2 | \
while read v; do
  expr $(cat count) + 1 > count
  while [ $(busy) -gt 42 ]; do
    echo "maxloop"
    sleep 60
    # echo "$(( 42 - ($(ps -C youtube-dl | wc -l) - 0) )) more"
  done
  echo -n "$(cat count):$v"
  if [ -z "$(find . -name "*-$v.opus")" ]; then
    echo "..."
    find . -name "$v.*p??" ! -name "*-$v.opus" -delete
    rm ../logs/**$v.*o? 2> /dev/null && echo "Deleted old log"
    bash ../dl.single.sh "$v" "$3" "$4" "$(if [ -n "$5" ]; then cat count; fi)" &> "../logs/$v.log" &
  else
    echo " already exists in directory"
  fi
  echo "$v" >> list
# if [ $(cat count) -ge 2 ]; then sleep 2; break; fi
done

echo "loop ($(busy) left)"
while [ $(busy) -gt 0 ]; do
  sleep 10
  echo "loop ($(busy) left)"
done
echo unloop
