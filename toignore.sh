#!/bin/sh
# shellcheck disable=SC2002
cd ~/dl/ignore/ || exit
cat ~/Music/maybe\ remove.m3u | \
grep '\[...........]' | \
sed 's/^Music\/dl\///; s/\/.*\[/\t/; s/].m4a//' | \
while read -r i; do echo "youtube ${i#*	}" | tee /dev/fd/2 >>"./${i%	*}.archive";echo "	\\-> ./${i%	*}.archive" >/dev/fd/2; done
rm ~/Music/maybe\ remove.m3u
