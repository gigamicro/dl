#!/bin/sh
archivedir="$(cat "$(dirname "$0")/archivedir")"
basedir="$(   cat "$(dirname "$0")/basedir")"
exec 3>&2
mkdir -p /tmp/dl; exec 3>/tmp/dl/archivecheckloose.log
# exec 3>/dev/null

# set arch
# set base
set "${1:-both}"

probe(){
	ffprobe -loglevel error -show_entries 'stream_tags:stream:format_tags:format' -i "$1" | \
	sed '
	/^TAG:comment=/,/^\(\[FORMAT]\|\[STREAM]\|TAG:[a-z]*=.*\)$/{  //!s/^/TAG:comment=/}
	/^\0nomatch\n\{666\}\0$/{}
	/^TAG:description=/,/^\(\[FORMAT]\|\[STREAM]\|TAG:[a-z]*=.*\)$/{  //!s/^/TAG:description=/}
	/^\0nomatch\n\{666\}\0$/{}
	/^TAG:synopsis=/,/^\(\[FORMAT]\|\[STREAM]\|TAG:[a-z]*=.*\)$/{  //!s/^/TAG:synopsis=/}

	/^TAG:\(synopsis\|description\)=/{
	s/[0-9][0-9][0-9][0-9] // # copyright YYYY asd
	s/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]// # updated on y-m-d
	}

	# /^TAG:\(synopsis\|album\|description\)=/s/ ([^(]*)$// # trim end parens

	/^TAG:\(synopsis\|description\)=/{
	s/\([a-z]*\), *\([a-z]*\)/\2 \1/i
	s///
	} # "a, b, a, b" -> "b a, "

	/^TAG:\(synopsis\|description\|comment\)=/s/   */ /g # collapse spaces

	/^TAG:artist=/s/Mad Vinnie Dead/BigNatesDad/
	' | \
	# grep -ve '=' -e '^\[' |
	# grep -e 'TAG:description' -e 'TAG:synopsis' |
	# tee -a /dev/fd/2 |
	{ tee /dev/fd/4 | grep 'TAG.*TAG' | sed 's/^/multiple TAGs in line: /' >&2; } 4>&1 | \
	{ tee /dev/fd/4 | grep '=.*[^vt]=' | sed 's/^/multiple equals in line: /' >&2; } 4>&1 | \
	grep -v \
	-e '^$' \
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
	-e '^DISPOSITION:[a-z]*=' \
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
	-e '^TAG:description=[Pp]laylist: http' \
	-e '^TAG:description=http' \
	-e '^TAG:ENCODER=' \
	-e '^TAG:encoder=' \
	-e '^TAG:handler_name=ISO Media file produced by Google Inc\.' \
	-e '^TAG:language=' \
	-e '^TAG:language=und$' \
	-e '^TAG:purl=http' \
	-e '^TAG:synopsis=[Pp]laylist: http' \
	-e '^TAG:synopsis=http' \
	-e '^TAG:vendor_id=\[0]\[0]\[0]\[0]$' \
	-e '^width='
}

dirs0(){
	[ "$1" != base ] && printf %s\\0 "$archivedir"
	[ "$1" != arch ] && printf %s\\0 "$basedir"
}

if [ "$1" != "-" ];then
{
[ "$1" != base ] && find "$archivedir" -type f \( -regex '.* \[[a-zA-Z0-9_-]*\]\.[0-9a-z.]*$' -o -regex '-[a-zA-Z0-9_-]\{11\}\.' \) -print0 | grep -zo '[^/]*/[^/]*$' | \
 sed -z 's/-[a-zA-Z0-9_-]\{11\}\..*$//; s/ \[[a-zA-Z0-9_-]*\]\.[0-9a-z.]*$//; t;d' | tr '[:lower:]' '[:upper:]' | { [ -z "$1" ] && sort -z | uniq -z || cat; }
[ "$1" != arch ] && find "$basedir"    -type f    -regex '.* \[[a-zA-Z0-9_-]*\]\.[0-9a-z.]*$'                                       -print0 | grep -zo '[^/]*/[^/]*$' | \
 sed -z                                's/ \[[a-zA-Z0-9_-]*\]\.[0-9a-z.]*$//; t;d' | tr '[:lower:]' '[:upper:]' | { [ -z "$1" ] && sort -z | uniq -z || cat; }
} |grep -zvie '^faV/'| sort -z | uniq -zd | "$(dirname "$0")/unpattern.sh" -z | tr \\0 \\n | while read -r i; do # get primary from duped pattern
	dirs0|find -files0-from - -type f -ipath "*/$i \[*].*" -printf "%C@ %p\\0"| sort -zrn | cut -zd\  -f2- |
	{ { tee /dev/fd/4 | grep -Fxzf "$(dirs0|find -files0-from - -type f -ipath "*/${i%/*}/$(basename "${i%/*}").m3u")"; } 4>&1 >&5 | cat;} 5>&1 | head -zn1
done | tr \\0 \\n
else cat;fi | while read -r i; do
	printf ' ? %s\n' "$i" >&3
	probei="$(probe "$i")"
	ip="$(printf %s "$i" | sed 'ss^.*/\([^/]*/[^/]*\)$s\1s;Td; s/ \[[a-zA-Z0-9_-]*\]\.[0-9a-z.]*$//; t;:d;d' | "$(dirname "$0")/unpattern.sh")"
	[ "$ip" = "" ] && continue
	dirs0|find -files0-from - -type f \( -ipath "*/$ip \[*].*" -o -ipath "*/$ip-???????????.*" \) | \
	while read j; do
		[ "$i" = "$j" ] && continue
		printf %s\\n "$probei" | { probe "$j" | { ! diff /dev/fd/4 -;}; } 4<&0 >&3 && { printf '< file=%s\n> file=%s\n' "$i" "$j" >&3; continue; }
		printf %s\\n "$j"
	done
done
