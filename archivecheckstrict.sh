#!/bin/sh
{
find "$(cat "$(dirname "$0")/archivedir")" -type f ! -name 'cover.*' ! -name '*.m3u' | xargs -L 1 -d '\n' basename -a | sort | uniq
find "$(cat "$(dirname "$0")/basedir")"    -type f ! -name 'cover.*' ! -name '*.m3u' | xargs -L 1 -d '\n' basename -a | sort | uniq
} | sort | uniq -d | \
while read -r i; do find "$(cat "$(dirname "$0")/archivedir")" | grep -F "$i"; done
#xargs -L 1 -rd '\n' find "$(cat "$(dirname "$0")/archivedir")" -type f -name
