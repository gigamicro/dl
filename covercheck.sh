#!/bin/sh
find "$(cat "$(dirname "$0")/basedir")" -name '*.m4a' | while read -r i; do
  if ffprobe "$i" 2>&1 | grep -q \(attached\ pic\); then
    if   [ -f "$(dirname "$i")/cover.png" ]; then
      echo "redundant: $i"
    fi
  else
    if ! [ -f "$(dirname "$i")/cover.png" ]; then
      echo "missing  : $i"
    fi
  fi
done
