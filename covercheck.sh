#!/bin/sh
find "$(cat "$(dirname "$0")/basedir")" ! -empty -name '*].*' | \
while read i; do (
  external="$(find "$(dirname "$i")" -name 'cover.*' | head -c 6)"
  if ffprobe -hide_banner -show_entries 'stream=codec_type' -select_streams v "$i" 2>&- | read qwe >/dev/null; then
    if [ -n "$external" ]; then
      printf 'redundant: %s\n' "$i"
    fi
  else
    if [ -z "$external" ]; then
      printf 'missing  : %s\n' "$i"
    fi
  fi
  ) & sleep 0.00625
done
wait
