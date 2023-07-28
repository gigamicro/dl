#!/bin/sh
# find "$(cat "$(dirname "$0")/basedir")" ! -path '*/faV/*' -type f ! -name 'cover.*' ! -name '*.m3u' | while read -r i; do
#   grep -F "${i##*/}" < "$(cat "$(dirname "$0")/basedir")"/faV/faV.m3u
# done
basedir="$(cat "$(dirname "$0")/basedir")"
find "$basedir" -type f -name '*.m3u' ! -name 'faV.m3u' | while read -r i; do
  cat "$basedir/faV/faV.m3u" "$i" | sort | uniq -d
done
# -name '*.m4a'
true
