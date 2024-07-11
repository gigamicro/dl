#!/bin/sh
{
find "$(cat "$(dirname "$0")/archivedir")" -type f | grep -o '[[-][a-zA-Z0-9_-]\{11\}[].]' | cut -c 2-12 | { [ -z "$1" ] && sort | uniq || cat; }
[ -z "$1" ] &&
find "$(cat "$(dirname "$0")/basedir")"    -type f | grep -o   '\[[a-zA-Z0-9_-]\{11\}\]'   | cut -c 2-12 | sort | uniq
} | sort | uniq -d | \
while read -r i; do find "$(cat "$(dirname "$0")/archivedir")" -type f -name "*[[-]${i}[].]*" | { [ -z "$1" ] && cat || tail -n+2; }; done
