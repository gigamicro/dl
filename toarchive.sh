#!/bin/sh
while read -r i; do
  dir="$(cat "$(dirname "$0")/archivedir")/$(basename "$(dirname "$i")")"
  mkdir -vp "$dir"
  mv -v "$i" -t "$dir"
  cp -vn "$(dirname "$i")/cover."* -t "$dir" 2>/dev/null
done
