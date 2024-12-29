#!/bin/sh
# by ID; pass a $1 to also check between file extensions
if [ "$1" ]; then
	a='s/]\.[^]]*$//;'
	b='].*'
fi
find "$(cat "$(dirname "$0")/basedir")" -type f | \
sed -e 'ss[^/]* \[s\ts;'"$a" | \
sort | uniq -d | "$(dirname "$0")/unpattern.sh" | \
while read -r i; do find "${i%	*}" -type f -name "* \[${i##*	}""$b" -print0 | xargs -0r stat -c '%Z %n' | sort -r | tail -n +2 | cut -c 12-; done
