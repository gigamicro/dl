#!/bin/sh
yt-dlp --embed-metadata --format 'ba*' -x \
youtube.com/playlist?list=OLAK5uy_lZnJ9OntnAqWRyDcdrCKDvXqTDJ9cNLmU \
--match-filter 'title*=nstrument' \
--embed-thumbnail --exec-before-download 'mv "%(title)s [%(id)s].webp" "./%(id)s.webp"; ffmpeg -hide_banner -i "./%(id)s.webp" -vf crop="min(in_w\,in_h):out_w" "%(title)s [%(id)s].webp"; rm "./%(id)s.webp"'
