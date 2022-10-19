#! /bin/bash
cd ~/Music
pkill syncthing
# rm -rf dl dlc logs dl*.err
# rm -rf dlc logs dl*.err
[ "$1" == "rm" ] && rm -rf dlc && echo "removed dlc"
[ "$2" == "rm" ] && rm -rf dl && echo "removed dl"
rm -rf logs dl*.err
(mkdir logs; mkdir logs/all) 2> /dev/null
echo -n $$ > logs/pid
( echo dl; bash dl.main.sh; echo dlc; bash dl.c.main.sh; echo "~FIN~" ) 2>&1 | tee "logs/all/$(date +"%Y%m%d%H%M%S%N").log"
rm logs/pid
(syncthing -no-browser > /tmp/syncthing.log &) & > /dev/null
