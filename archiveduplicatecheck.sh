#!/bin/sh
archivedir="$(cat "$(dirname "$0")/archivedir")"
find "$archivedir" -type f | grep -o '[[-][a-zA-Z0-9_-]\{11\}[].]' | cut -c 2-12 | sort | uniq -d | \
while read -r i; do
 find "$archivedir" -type f -name "*[[-]${i}[].]*" | sort | tail -n +2
done
# xargs -rd \\n stat -c '%Y %n' | sort | tail -n +2 | cut -c 12-
