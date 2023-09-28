#!/bin/sh
mv "$1" "$1\~"
ffmpeg -hide_banner -i "$1\~" -vf crop="in_h:out_w" "$1"
rm "$1\~"
