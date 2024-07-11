#!/bin/sh
archivedir="$(cat "$(dirname "$0")/archivedir")"
basedir="$(   cat "$(dirname "$0")/basedir")"
{
find "$archivedir" -type f | grep '[[-][a-zA-Z0-9_-]\{11\}[].]' | grep -o '[^/]*/[^/]*$' | grep -v '^faV/' | \
 sed 's/-[a-zA-Z0-9_-]\{11\}\..*$//; s/ \[[a-zA-Z0-9_-]\{11\}\]\..*$//' | tr '[:lower:]' '[:upper:]' | { [ -z "$1" ] && sort | uniq || cat; }
[ -z "$1" ] &&
find "$basedir"    -type f | grep   '\[[a-zA-Z0-9_-]\{11\}\]'   | grep -o '[^/]*/[^/]*$' | grep -v '^faV/' | \
 sed 's/ \[[a-zA-Z0-9_-]\{11\}\]\..*$//'  | tr '[:lower:]' '[:upper:]' | sort | uniq
} | sort | uniq -d | \
"$(dirname "$0")/unpattern.sh" | while read -r i; do
{
	find "$(cat "$(dirname "$0")/basedir")/" "$archivedir/" -type f \
	-ipath "*/$i \[*].*" -o -ipath "*/$i-???????????.*" | \
	# { printf '%s\n' "$i" >&2; cat; } | \
	xargs -rd \\n -n 1 ffprobe -loglevel error -show_entries 'stream_tags:stream:format_tags:format' | \
	grep -v \
	-e '^bit_rate=' \
	-e '^codec_long_name=' \
	-e '^codec_name=' \
	-e '^codec_primaries=' \
	-e '^codec_tag=' \
	-e '^codec_tag_string=' \
	-e '^coded_height=' \
	-e '^coded_width=' \
	-e '^color_primaries=' \
	-e '^display_aspect_ratio=' \
	-e '^DISPOSITION=' \
	-e '^extradata_size=' \
	-e '^filename=' \
	-e '^format_long_name=' \
	-e '^format_name=' \
	-e '^height=' \
	-e '^id=.x.$' \
	-e '^initial_padding=' \
	-e '^nb_frames=' \
	-e '^profile=' \
	-e '^sample_aspect_ratio=' \
	-e '^sample_rate=' \
	-e '^size=' \
	-e '^TAG:[a-z]*=Provided to YouTube by ' \
	-e '^TAG:comment=Cover (front)$' \
	-e '^TAG:comment=http' \
	-e '^TAG:compatible_brands=' \
	-e '^TAG:date=[0-9]*$' \
	-e '^TAG:ENCODER=' \
	-e '^TAG:encoder=' \
	-e '^TAG:handler_name=ISO Media file produced by Google Inc\. Created on: [/0-9]*\.$' \
	-e '^TAG:language=und$' \
	-e '^TAG:purl=http' \
	-e '^TAG:vendor_id=\[0]\[0]\[0]\[0]$' \
	-e '^width=' \
	| sort | uniq -u | tee -a /dev/fd/2 | { ! grep '' -m1 >&2;} || { printf %s\\n "$i" | tee -a /dev/fd/2 | tr -c \\n - >&2; false;}
} && find "$archivedir/" -type f -ipath "*/$i \[*].*" -o -ipath "*/$i-???????????.*" | { [ -z "$1" ] && cat || sort|tail -n+2; } || true
done
