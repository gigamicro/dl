#!/bin/sh
cd ~/dl/ignore/
cat ~/Music/maybe\ remove.m3u | \
grep '\[...........]' | \
sed 's/^Music\/dl\///; s/\/.*\[/\t/; s/].m4a//' | \
while read i; do echo "youtube ${i#*	}" | tee "./${i%	*}.archive" ;echo '	->';echo "./${i%	*}.archive"; done
