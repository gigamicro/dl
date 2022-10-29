#! /bin/bash
echo $$

echo json
yt-dlp "https://youtube.com/watch?v=$1" -o "$1" --skip-download --write-info-json
if [ $? != 0 ]; then echo "error ! https://youtu.be/$1"; exit 1; fi
mv "./$1.info.json" "./$1.json"

num=$2
if [ -z "$num" ]; then
echo image
bash ~/Music/dl.single.image.sh "$1" || echo "No image"
fi
echo audio
bash ~/Music/dl.single.audio.sh "$1" || echo "No audio"

echo probe
ffprobe -hide_banner ./$1.png
ffprobe -hide_banner ./$1.opus

echo proc
id="$1"
jsonget() { jq -r "$1//empty" < "./$id.json"; }
# jq<./$1.json # Output entire json file
nameid="$(jsonget '.title+"-"+.id' | sed -e 's/[<>:"\/\\|?*]/_/g')"
[ -f trim.sh ] && nameid=$(bash trim.sh <<< "$nameid")
echo "$nameid"

if [ -z "$num" ]; then
echo "Opusdec: $num"
opusdec --force-wav "./$1.opus" "./$1.wav" | grep -v '^\[[/\\-|]\] \d\d:\d\d:\d\d$'
echo "Opusenc: $num"
opusenc \
--picture "./$1.png" \
--album "$(jsonget '.album')" \
--title "$(jsonget '.title')" \
--date  "$(jsonget '.upload_date')" \
--comment purl="$(jsonget '.webpage_url')" \
--artist "$(jsonget '.artist')" \
--comment description="$(jsonget '.description')" \
"./$1.wav" "./$nameid.opus"
else # imageless
echo "FFmpeg: $num"
ffmpeg -hide_banner -i "./$1.opus" -c:a copy \
-metadata picture="./cover.png" \
-metadata album="$(jsonget '.album')" \
-metadata title="$(jsonget '.title')" \
-metadata date="$(jsonget '.upload_date')" \
-metadata purl="$(jsonget '.webpage_url')" \
-metadata artist="$(jsonget '.artist')" \
-metadata description="$(jsonget '.description')" \
-metadata track=$num \
"./$nameid.opus"
fi

echo "probe"
ffprobe -hide_banner "./$nameid.opus"

# mv -n ./$1.json ../logs/
# rm ./$1.{json, opus}
if [ -f "./$nameid.opus" ]; then
	rm ./$1.*
else
	rm ./$1.json ./$1.wav
	echo "$1" >> err
fi
