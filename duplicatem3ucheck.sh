#!/bin/sh
basedir="$(cat "$(dirname "$0")/basedir")"
{
  find "$basedir" -type f -name '*.m3u' ! -name "$1.m3u" -print0 | xargs -0 cat | sort | uniq
  cat  "$basedir/$1/$1.m3u" | grep -v '^$' | sort | uniq
} | sort | uniq -d | sed "s/^.\//$(printf %s "$basedir/$1/" | sed 'ss/s\\/sg')/"
