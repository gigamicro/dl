#!/bin/sh
find "$(cat "$(dirname "$0")/basedir")" -type f | grep -o '\[[a-zA-Z0-9_-]\{11\}\]' | cut -c 2-12 | sort | uniq -d | \
while read -r i; do find "$(cat "$(dirname "$0")/basedir")" -type f -name "*[[-]${i}[].]*" | xargs -d \\n dirname | uniq -u | sed 's/$/\t'"$i"'/'; done | \
while read -r i; do find "${i%	*}" -type f -name "*[[-]${i##*	}[].]*"; done
