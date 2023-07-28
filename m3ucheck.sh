#!/bin/sh
find "$(cat "$(dirname "$0")/basedir")" -type f ! -name 'cover.*' ! -name '*.m3u' | while read -r i; do
  cat "$(dirname "$i")"/*.m3u | grep -qF "$(basename "$i")" || echo "$i"
done
true
