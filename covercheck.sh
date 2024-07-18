#!/bin/sh
find "$(cat "$(dirname "$0")/basedir")" ! -empty -name '* \[*].*' | \
while read i; do (
  # printf . >&2
  external="$(find "$(dirname "$i")" -name 'cover.*' | head -c 1)"
  dims="$(ffprobe -hide_banner -show_entries 'stream=width,height' -select_streams v "$i" 2>&- | grep = | tr '\n' ' ')"
  [ -n "$external" ] && [ -n "$dims" ] && printf 'redundant: %s\n' "$i" && exit
  [ -z "$external" ] && [ -z "$dims" ] && printf 'missing  : %s\n' "$i" && exit
  [ -z "$external" ] && ! printf '%s\n' "$dims" | grep '^width=\([0-9]*\) height=\1 $' >/dev/null && printf 'nonsquare: %s\n' "$i" && exit
  # printf ! >&2
) & sleep 0.0005; done
# echo cover checks launched >&2
wait
