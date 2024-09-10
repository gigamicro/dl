#!/bin/sh
archivedir="$(cat "$(dirname "$0")/archivedir")"
basedir="$(cat "$(dirname "$0")/basedir")"
# set y;archivedir="$basedir"
{
find "$archivedir" -type f | grep -oe ' \[[a-zA-Z0-9_-]*\]\.[0-9a-z.]*$' -e '-[a-zA-Z0-9_-]\{11\}\.opus$' |
 cut -d . -f 1 | sed 's/^-//; s/^ \[//; s/]$//' | { [ -z "$1" ] && sort | uniq || cat; }
[ -z "$1" ] &&
find "$basedir"    -type f | grep -o  ' \[[a-zA-Z0-9_-]*\]\.[0-9a-z.]*$' | cut -c 3- | cut -d ] -f 1 | sort | uniq
} | sort | uniq -d | \
while read -r i; do find "$archivedir" -type f -name "* \[$i].*" -o -name "*-$i.*" | { [ -z "$1" ] && cat || tail -n+2; }; done
