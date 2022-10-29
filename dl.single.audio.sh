#! /bin/bash
ffmpeg -hide_banner \
-i "$(yt-dlp "https://youtube.com/watch?v=$1" -f bestaudio[acodec=opus] --get-url)" \
-vn \
-c:a copy \
"./$1.opus" || (
echo Downloading non-opus original...
ffmpeg -hide_banner \
-i "$(yt-dlp "https://youtube.com/watch?v=$1" -f bestaudio --get-url)" \
-vn \
-c:a libopus \
"./$1.opus"
)
