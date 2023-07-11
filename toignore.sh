#!/bin/sh
# shellcheck disable=SC2002
scriptdir="$(dirname "$0")"
[ -f ~/Music/maybe\ remove.m3u ] || exit 0
mkdir "$scriptdir/ignore/" 2>/dev/null
cd "$scriptdir/ignore/" || exit
cat ~/Music/maybe\ remove.m3u | \
grep '\[...........]' | \
sed 's/^Music\/dl\///; s/\/.*\[/\t/; s/].m4a//' | \
while read -r i; do echo "youtube ${i#*	}" | tee /dev/fd/2 >>"./${i%	*}.archive";echo "	\\-> ./${i%	*}.archive" >/dev/fd/2; done
rm ~/Music/maybe\ remove.m3u
