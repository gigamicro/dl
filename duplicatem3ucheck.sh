#!/bin/sh
[ -z "$1" ] && set "$(cat "$(dirname "$0")/basedir")/faV"
{
  find "$1/.." -type f -name '*.m3u' ! -name "${1##*/}.m3u" -print0 | xargs -0 cat | sort | uniq
  cat  "$1/${1##*/}.m3u" | grep -v '^$' | sort | uniq
} | sort | uniq -d | sed "s/^.\//$(printf %s "$1/" | sed 'ss/s\\/sg')/"
