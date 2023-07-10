#!/bin/sh
ls -d ~/Music/dl/* | while read f; do
  # echo "\t$f"
  ls -d "$f"/*.m4a | while read i; do
    grep -qF "${i##*/}" < "$f/${f##*/}.m3u" || echo "$i"
  done
done
true
