#! /bin/bash
cd ~/Music
pkill syncthing
date +"%FT%T" >> ~/dl-times

[ "$1" == "rm" ] && rm -rf dlc && echo "removed ./dlc"
rm -rf logs dlc.*.err
(mkdir logs; mkdir logs/all) 2> /dev/null
echo -n $$ > logs/pid
bash dl.c.main.sh 2>&1 | tee "logs/all/$(date +"%Y%m%dT%H%M%S.%N").log"
rm logs/pid

(syncthing -no-browser > /tmp/syncthing.log &) & > /dev/null
(sleep 360; rm -d logs/dl* && rm -r logs)& >/dev/null
