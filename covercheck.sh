#!/bin/sh
find "$(cat "$(dirname "$0")/basedir")" -name '*.m4a' ! -empty | while read -r i; do (
  if ffprobe "$i" 2>&1 | grep -q \(attached\ pic\); then
    if [ -n "$(find "$(dirname "$i")" -name 'cover.*' | head -c 6)" ]; then
      echo "redundant: $i"
    fi
  else
    if [ -z "$(find "$(dirname "$i")" -name 'cover.*' | head -c 6)" ]; then
      echo "missing  : $i"
    fi
  fi
  ) & sleep 0.00625
done
# ps;echo ===;wait;ps
wait
