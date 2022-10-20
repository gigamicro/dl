#! /bin/bash
yt-dlp "https://youtube.com/watch?v=$1" -i -f bestaudio[acodec=opus] --get-url | ffmpeg -hide_banner -i "$(cat)" -vn -c:a copy "./$1.opus" || (
echo Downloading non-opus original...
yt-dlp "https://youtube.com/watch?v=$1" -i -f bestaudio --get-url | ffmpeg -hide_banner -i "$(cat)" -vn -c:a libopus "./$1.opus"
)
# --add-metadata 
