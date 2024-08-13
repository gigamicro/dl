#!/bin/sh
find "$(cat "$(dirname "$0")/basedir")" -type f | \
sed 'ss[^/]* \[s\ts' | \
sort | uniq -d | \
while read -r i; do find "${i%	*}" -type f -name "* \[${i##*	}" -print0 | xargs -0r stat -c '%Z %n' | sort -r | tail -n +2 | cut -c 12-; done
