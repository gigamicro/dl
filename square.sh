#!/bin/sh
[ -n "$1" ] || exit 1
[ -f "$1" ] || exit 2
mv -v "$1" "${1%?}~" || exit 3
ffmpeg -hide_banner -i "${1%?}~" -vf crop=\''min(in_h\,in_w):out_w'\' "$1" || { mv -v "${1%?}~" "$1"; exit 4; }
rm -v "${1%?}~" || exit 5
