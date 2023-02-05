#!/bin/sh
cat maybe\ remove.m3u | \
grep '\[...........]' | \
sed 's/^Music\/dl\///; s/\/.*\[/\t/; s/].m4a//' | \
while read i; do echo "youtube ${i#*	}" >> "./${i%	*}.archive"; done
