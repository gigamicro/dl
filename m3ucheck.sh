#!/bin/sh
find "$(cat "$(dirname "$0")/basedir")"/ -maxdepth 1 -mindepth 1 -type d | 
while read -r d; do
  if find "$d" -name "*.archive" -print -quit | grep '' -qm 1; then
    printf 'archive file in %s\n' "$d" >&2
  else
    mmmu="${d}/${d##*/}.m3u"
    [ -f "$mmmu" ] ||{ printf 'no m3u in %s\n' "$d" >&2;continue;}
    cd "$d" || continue
    find . -type f ! -name 'cover.*' ! -name '*.m3u' -print0 | grep -zvFxf "$mmmu" | xargs -0rn1 printf '%s/%s\n' "$d" | sed 'ss/\./s/s'
  fi
done
true
