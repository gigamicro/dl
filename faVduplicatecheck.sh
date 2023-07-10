#!/bin/sh
ls -d ~/Music/dl/* | grep -v '/faV$' | while read f; do
  # echo "\t$f"
  ls -d "$f"/*.m4a | while read i; do
    grep -F "${i##*/}" < ~/Music/dl/faV/faV.m3u
  done
done
true
