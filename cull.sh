#!/bin/sh
find "${1:-.}" -maxdepth 1 -type d | while read -r i; do
  [ -z "$(find "$i" -type f ! -name 'cover.*' ! -name '*.m3u' ! -name '*.archive' | head -c 6)" ] && echo "$i"
done | xargs -rd \\n rm -rv
