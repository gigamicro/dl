#!/bin/sh
find "$(cat "$(dirname "$0")/basedir")" -type f ! -name 'cover.*' ! -name '*.m3u' | while read -r i; do
  grep -qFe "$(basename "$i")" -- "$(dirname "$i")"/*.m3u || printf '%s\n' "$i"
done
true
