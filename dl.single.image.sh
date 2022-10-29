#! /bin/bash
ffmpeg -hide_banner \
-i "$(yt-dlp "https://youtube.com/watch?v=$1" -f bestvideo --get-url)" \
-ss $(($(jq ".duration" <"./$1.json") / 2)) \
-vframes 1 \
"./$1.png"
