#!/bin/sh
{
find "$(cat "$(dirname "$0")/archivedir")" -type f | grep -o '[[-][a-zA-Z0-9_-]\{11\}[].]' | cut -c 2-12 | sort | uniq
find "$(cat "$(dirname "$0")/basedir")"    -type f | grep -o   '\[[a-zA-Z0-9_-]\{11\}\]'   | cut -c 2-12 | sort | uniq
} | sort | uniq -d | \
while read -r i; do find "$(cat "$(dirname "$0")/archivedir")" -type f -name "*$i*"; done
# while read -r i; do find ~/Music/ -name "*$i*"; done
# | \
# grep Music/local/arch | 
# while read -r i; do mkdir /tmp/musdiscards 2>/dev/null; mv -v "$i" /tmp/musdiscards; done
