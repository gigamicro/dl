#!/bin/sh
archivedir="$(cat "$(dirname "$0")/archivedir")"
basedir="$(   cat "$(dirname "$0")/basedir")"
{
find "$archivedir" -type f | grep '[[-][a-zA-Z0-9_-]\{11\}[].]' | grep -o '[^/]*/[^/]*$' | grep -v '^faV/' | \
 sed 's/-[a-zA-Z0-9_-]\{11\}\..*$//; s/ \[[a-zA-Z0-9_-]\{11\}\]\..*$//' | tr '[:lower:]' '[:upper:]' | sort | uniq
find "$basedir"    -type f | grep   '\[[a-zA-Z0-9_-]\{11\}\]'   | grep -o '[^/]*/[^/]*$' | grep -v '^faV/' | \
 sed 's/ \[[a-zA-Z0-9_-]\{11\}\]\..*$//'  | tr '[:lower:]' '[:upper:]' | sort | uniq
} | sort | uniq -d | \
"$(dirname "$0")/unpattern.sh" | while read -r i; do
	# printf "%s\n" "$i" >&2
	{
	# [ "${i%/*}" = "Epic Mountain" ] || \
	# [ "${i%/*}" = "Mad Rat Dead" ] || \
	# [ "${i%/*}" = "MAD RAT DEAD" ] || \
	# [ "$i" = "Vertigoaway/MarketingResearch" ] || \
	# [ "${i%/*}" = "OVERWERK" ] || \
	[ "$(
		# find "$(cat "$(dirname "$0")/basedir")/${i%/*}" "$archivedir/${i%/*}" \
		find \
		"$(find "$(cat "$(dirname "$0")/basedir"   )/" -type d -iname "${i%/*}")" \
		"$(find "$archivedir/" -type d -iname "${i%/*}")" \
		-type f \( -iname "${i#*/} \[*].*" -o -iname "${i#*/}-???????????.*" \) | \
		{ printf '%s\n' "$i" >&2; cat; } | \
		# { tee -a /dev/fd/2; } | \
		xargs -d \\n -n 1 ffprobe -loglevel error -show_entries \
		'stream_tags=comment,description,synopsis,artist,title,album : stream=duration
		:format_tags=comment,description,synopsis,artist,title,album : format=duration' | \
		# ,width,height,sample_rate
		tr '[:upper:]' '[:lower:]' \
		|sed \
		-e 's/:comment=/:synopsis=/;s/:description=/:synopsis=/;' \
		-e '/:artist=/s/,.*//; /:artist=/s/ feat.*//; /:artist=/s/ - topic$//; /duration=/s/\.[0-9]*$//;' \
		|grep -v \
		-e 'youtube.com/watch' \
		-e ':synopsis=cover (front)'  \
		-e ':album='  \
		|\
		# -e ':artist=bignatesdad' -e ':artist=mad vinnie dead' \
		# -e '℗ armada springs' -e ':synopsis=provided to youtube by distrokid' \
		# -e :comment= -e :synopsis= -e :date= -e :handler_name= \
		sort | uniq -u | tee -a /dev/fd/2 | wc -l
	)" -eq 0 ] || { printf "%s\n\n" "$i" >&2 ;false;}; } && \
	find "$archivedir/" -ipath "${i} \[*].*" -o -ipath "${i}-???????????.*"
	# echo>&2
done #>/dev/null #2>/dev/null
