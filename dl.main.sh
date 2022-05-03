#! /bin/bash
# rm -rf logs/dl dl dl.err
mkdir dl 2> /dev/null
cd dl
mkdir ../logs/ 2> /dev/null
mkdir ../logs/dl 2> /dev/null

# for i in {1..500..32}; do
  bash ../dl.playlist.sh PLvryg3_lQyMCgnGmhpyjuFt3QtFL_6lO2 # " --playlist-start $i --playlist-end $(($i+31)) $1" " $2"

  mv -n ../logs/*.log ../logs/*.json ../logs/dl/ 2>/dev/null || echo "No logs" >&2
  rm ../logs/*.log ../logs/*.json 2>/dev/null || echo "No ignored logs" >&2

  echo done at $(date)
# done

> dl.m3u # empty
while read i; do
  echo ./*-$i.opus >> dl.m3u
done < list

rm list count
# mv list count ..
# cat <(echo "-----------") err > ../dl.err
mv err ../dl.err
cd ..


# echo writing playlist
# echo 0 > count
# echo "[playlist]" > list.pls
# echo -n "" > list.m3u
# cat list | while read i; do
#   expr $(cat count) + 1 > count
#   echo "File$(cat count)=$(echo -n ./*/*$i.opus)" >> list.pls
#   echo "$(echo -n ./*/*$i.opus)" >> list.m3u
# done
# echo "NumberOfEntries=$(cat count)" >> list.pls
# mv list.pls "./dl.pls"
# mv list.m3u "./dl.m3u"
# rm list count

echo complete at $(date)
