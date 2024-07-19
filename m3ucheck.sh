#!/bin/sh
find "$(cat "$(dirname "$0")/basedir")"/ -maxdepth 1 -mindepth 1 -type d | while read -r d; do
  # printf . >&2
  if find "$d" -name "*.archive" -print -quit | grep '' -qm 1; then
    printf 'archive file in %s\n' "$d" >&2
  else
    find "$d/." -type f ! -name 'cover.*' ! -name '*.m3u' | grep -vFf "$d"/"${d##*/}".m3u | sed 'ss/\./s/s'
  fi
done
true
