#!/bin/sh
archivedir="$(cat "$(dirname "$0")/archivedir")"
basedir="$(   cat "$(dirname "$0")/basedir")"
exec 3>&2
exec 3>/dev/null
{
find "$archivedir" -type f -regex '.* \[[a-zA-Z0-9_-]*\]\.[0-9a-z.]*$' -o -regex '-[a-zA-Z0-9_-]\{11\}\.' | grep -o '[^/]*/[^/]*$' | \
 sed 's/-[a-zA-Z0-9_-]\{11\}\..*$//; s/ \[[a-zA-Z0-9_-]*\]\.[0-9a-z.]*$//; t;d' | tr '[:lower:]' '[:upper:]' | { [ -z "$1" ] && sort | uniq || cat; }
[ -z "$1" ] &&
find "$basedir"    -type f -regex '.* \[[a-zA-Z0-9_-]*\]\.[0-9a-z.]*$' | grep -o '[^/]*/[^/]*$' | \
 sed 's/ \[[a-zA-Z0-9_-]*\]\.[0-9a-z.]*$//; t;d'  | tr '[:lower:]' '[:upper:]' | sort | uniq
} | sort | uniq -d | \
"$(dirname "$0")/unpattern.sh" | while read -r i; do
{
	find "$(cat "$(dirname "$0")/basedir")/" "$archivedir/" -type f \
	-ipath "*/$i \[*].*" -o -ipath "*/$i-???????????.*" | \
	# { printf '%s\n' "$i" >&2; cat; } | \
	# tee -a /dev/fd/2 | \
	xargs -rd \\n -n 1 ffprobe -loglevel error -show_entries 'stream_tags:stream:format_tags:format' | \
	sed '
	/^TAG:comment=/,/^[]/[FORMATSTREAMTAG:synopsisdescription]\{9\}/{
		/^TAG:comment=/bacomment;
		/^[]/[FORMATSTREAMTAG:synopdescr]\{9\}/bacomment;
		s/^/TAG:comment=/
	};:acomment;
	/^TAG:description=/,/^[a-zA-Z:_]\{2,\}=/{
		/^[a-zA-Z:_]\{2,\}=/badescription;
		s/^/TAG:description=/
	};:adescription;
	/^TAG:synopsis=/,/^\[\/FORMAT]$/{
		/^TAG:synopsis=/basynopsis;
		/^\[\/FORMAT]$/basynopsis;
		s/^/TAG:synopsis=/
	};:asynopsis;

	/TAG:synopsis=/bdates;
	/TAG:description=/bdates;
	badates;:dates;
	s/[0-9][0-9][0-9][0-9] //;Tadates;
	s/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]//;Tadates;
	:adates;

	# /TAG:synopsis=/bparens;
	# /TAG:album=/bparens;
	# /TAG:description=/bparens;
	# baparens;:parens;
	# s/ ([^(]*)$//;Taparens;
	# :aparens;

	/TAG:synopsis=/bcommas;
	/TAG:description=/bcommas;
	bacommas;:commas;
	s/\([a-z]*\), *\([a-z]*\)/\2 \1/i;Tacommas;
	s///;Tacommas;
	:acommas;

	/TAG:synopsis=/bmisc;
	/TAG:description=/bmisc;
	bamisc;:misc;
	s/   */ /g
	:amisc;
	/TAG:artist=/s/Mad Vinnie Dead/BigNatesDad/
	' | \
	# grep -ve '=' -e '^\[' |
	# grep -e 'TAG:description' -e 'TAG:synopsis' |
	# tee -a /dev/fd/2 |
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
	-e '^width=' \
	| sort | uniq -ui | tee -a /dev/fd/3 | { ! grep '' -qm1;} || { printf %s\\n "$i" | tee -a /dev/fd/3 | tr -c \\n - >&3; false;}
} && find "$archivedir/" -type f -ipath "*/$i \[*].*" -o -ipath "*/$i-???????????.*" | { [ -z "$1" ] && cat || sort|tail -n+2; } || true
done

# [ -n "$1" ] || { echo ====== >&2; "$0" arch; }
