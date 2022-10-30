#! /bin/bash
cd ~/Music
pkill syncthing

# [ "$1" == "rm" ] && rm -rf dlc && echo "removed ./dlc"
rm -rf logs dlc.*.err
mkdir logs
echo -n $$ > logs/pid
bash dl.c.main.sh 2>&1 | tee "logs/$(date +"%Y%m%dT%H%M%S.%N").log"
rm logs/pid

(syncthing -no-browser > /tmp/syncthing.log &) & > /dev/null
(sleep 3600; rm -rf logs)& >/dev/null
