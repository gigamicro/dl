#!/bin/sh
ls -d ~/Music/dl/* | while read f; do
  echo "\t$f"
  ls -d "$f"/*.m4a | while read i; do
    if ffprobe "$i" 2>&1 | grep -q \(attached\ pic\); then
      # echo 'y'
      if [ -f "$f/cover.png" ]; then
        echo 'has cover and gen cover:' "$i"
      # else
      #   echo 'y'
      fi
    else
      # echo 'n'
      if [ -f "$f/cover.png" ]; then
        # echo 'n'
        true
      else
        echo 'has no cover or gen cover:' "$i"
      fi
    fi
  done
done
