#! /bin/bash
a=$1; youtube-dl "https://youtube.com/watch?v=$a" -i -f bestvideo --get-url | ffmpeg -hide_banner -i "$(cat)" -ss 10 -vframes 1 "./$a.png" || (
# echo Replacing with 1x1...
# base64 -d <<< "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=" > "./$a.png"
echo no image!
)