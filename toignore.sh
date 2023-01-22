#!/bin/sh
cat maybe\ remove.m3u | \
grep '\[...........]' | \
sed 's/^Music\/yt\///; s/\/.*\[/\t/; s/].m4a//' | \
while read i; do echo "youtube ${i#*       }" >> "/home/gigamicro/dl/ignore/${i%        *}.archive"; done
