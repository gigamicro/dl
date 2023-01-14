#!/bin/sh
mv "$1" "$1\~"
ffmpeg -hide_banner -i "$1\~" -vf crop="min(in_w\,in_h):out_w" "$1"
rm "$1\~"