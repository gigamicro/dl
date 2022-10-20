#! /bin/bash
echo $$
echo json
youtube-dl "https://youtube.com/watch?v=$1" -o "$1" --skip-download --write-info-json; if [ $? != 0 ]; then echo error !; exit 1; fi; mv "./$1.info.json" "./$1.json"
if [ -z "$4" ]; then
echo image
bash ~/Music/dl.single.image.sh "$1" "$3"
fi
echo audio
bash ~/Music/dl.single.audio.sh "$1" "$2"

echo probe
ffprobe -hide_banner ./$1.png
ffprobe -hide_banner ./$1.opus

echo proc
a="$1"
# trim() { echo -n -e ${1:1:-1}; }
jsonget() { jq -r "$1//empty" < "./$a.json"; }
# cat ./$1.json | jq # Output entire json file
# 3>&1 1>&2 2>&3
nameid="$(jsonget '.title+"-"+.id' | sed -e 's/[<>:"\/\\|?*]/_/g')"
[ -f trim.sh ] && nameid=$(bash trim.sh <<< "$nameid")
echo "$nameid"

if [ -z "$4" ]; then
echo "Opusdec: $4"
opusdec --force-wav "./$1.opus" "./$1.wav" | grep -v '^\[[/\\-|]\] \d\d:\d\d:\d\d$'
echo "Opusenc: $4"
opusenc \
--picture "./$1.png" \
--album "$(jsonget '.album')" \
--title "$(jsonget '.title')" \
--date  "$(jsonget '.upload_date')" \
--comment purl="$(jsonget '.webpage_url')" \
--artist "$(jsonget '.artist')" \
--comment description="$(jsonget '.description')" \
"./$1.wav" "./$nameid.opus"
else
echo "FFmpeg: $4"
# metadata() { valu="$(jsonget "$1" sed -z 's/\r?\n/\\\n/g')"; if [ "$valu" != "null" ]; then cat <<< "-metadata $2=\"$valu\""; fi; }
ffmpeg -hide_banner -i "./$1.opus" -c:a copy \
-metadata picture="./cover.png" \
-metadata album="$(jsonget '.album')" \
-metadata title="$(jsonget '.title')" \
-metadata date="$(jsonget '.upload_date')" \
-metadata purl="$(jsonget '.webpage_url')" \
-metadata artist="$(jsonget '.artist')" \
-metadata description="$(jsonget '.description')" \
-metadata track=$4 \
"./$nameid.opus"
# $(metadata '.album' 'album') \
# $(metadata '.title' 'title') \
# $(metadata '.upload_date' 'date') \
# $(metadata '.webpage_url' 'purl') \
# $(metadata '.artist' 'artist') \
# $(if [ -n $4 ]; then echo -n "-metadata track=$4"; fi) \
#
# $(metadata '.description' 'description') \
# -metadata album="$(jsonget '.album')" \
# -metadata title="$(jsonget '.title')" \
# -metadata date="$(jsonget '.upload_date')" \
# -metadata purl="$(jsonget '.webpage_url')" \
# -metadata artist="$(jsonget '.artist')" \
# -metadata description="$(jsonget '.description')" \
# $(if [ "Null" != "$(jsonget '.x')" ]; then echo -n "-metadata x=\"$(jsonget '.x')\""; fi) \
fi

echo "probe"
ffprobe -hide_banner "./$nameid.opus"

# mv -n ./$1.json ../logs/
# rm ./$1.{json, opus}
if [ -f "./$nameid.opus" ]; then rm ./$1.*; else rm ./$1.json ./$1.wav; echo "$1" >> err; fi
