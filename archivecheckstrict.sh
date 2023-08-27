#!/bin/sh
{
find "$(cat "$(dirname "$0")/archivedir")" -type f ! -name 'cover.*' ! -name '*.m3u' | xargs -L 1 -d '\n' basename -a | sort | uniq
find "$(cat "$(dirname "$0")/basedir")"    -type f ! -name 'cover.*' ! -name '*.m3u' | xargs -L 1 -d '\n' basename -a | sort | uniq
} | sort | uniq -d | \
while read -r i; do find "$(cat "$(dirname "$0")/archivedir")" | grep -F "$i"; done
#xargs -L 1 -rd '\n' find "$(cat "$(dirname "$0")/archivedir")" -type f -name
# while read -r i; do find ~/Music/ -name "*$i*"; done
# | \
# grep Music/local/arch | 
# while read -r i; do mkdir /tmp/musdiscards 2>/dev/null; mv -v "$i" /tmp/musdiscards; done
