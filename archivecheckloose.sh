#!/bin/sh
unpattern(){ printf %s "$1" | sed 's/\\/\\\\/g;s/\*/\\*/g;s/\?/\\?/g;s/\!/\\!/g;s/\[/\\[/g';}
{
find "$(cat "$(dirname "$0")/archivedir")" -type f | grep '[[-][a-zA-Z0-9_-]\{11\}[].]' | grep -o '[^/]*/[^/]*$' | grep -v '^faV/' | \
 sed 's/-[a-zA-Z0-9_-]\{11\}\..*$//; s/ \[[a-zA-Z0-9_-]\{11\}\]\..*$//' | tr '[:lower:]' '[:upper:]' | sort | uniq
find "$(cat "$(dirname "$0")/basedir")"    -type f | grep   '\[[a-zA-Z0-9_-]\{11\}\]'   | grep -o '[^/]*/[^/]*$' | grep -v '^faV/' | \
 sed 's/ \[[a-zA-Z0-9_-]\{11\}\]\..*$//'  | tr '[:lower:]' '[:upper:]' | sort | uniq
} | sort | uniq -d | \
while read -r i; do
	# printf "%s\n" "$i" >/dev/fd/2
	{
	# [ "${i%/*}" = "Epic Mountain" ] || \
	# [ "${i%/*}" = "Mad Rat Dead" ] || \
	# [ "${i%/*}" = "MAD RAT DEAD" ] || \
	# [ "$i" = "Vertigoaway/MarketingResearch" ] || \
	# [ "${i%/*}" = "OVERWERK" ] || \
	[ "$(
		# find "$(cat "$(dirname "$0")/basedir")/${i%/*}" "$(cat "$(dirname "$0")/archivedir")/${i%/*}" \
		find \
		"$(find "$(cat "$(dirname "$0")/basedir"   )/" -type d -iname "$(unpattern "${i%/*}")")" \
		"$(find "$(cat "$(dirname "$0")/archivedir")/" -type d -iname "$(unpattern "${i%/*}")")" \
		-type f -iname "$(unpattern "${i#*/}")[- ][[a-zA-Z0-9_-]??????????[.a-zA-Z0-9_-][]a-zA-Z0-9]*" | \
		{ echo "$i" >>/dev/fd/2; cat; } | \
		# { tee /dev/fd/2; } | \
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
	)" -eq 0 ] || { printf "%s\n\n" "$i" >/dev/fd/2 ;false;}; } && \
	find "$(find "$(cat "$(dirname "$0")/archivedir")/" -type d -iname "$(unpattern "${i%/*}")")" \
		-type f -iname "$(unpattern "${i#*/}")[- ][[a-zA-Z0-9_-]??????????[.a-zA-Z0-9_-][]a-zA-Z0-9]*"
	# echo>/dev/fd/2
done #>/dev/null #2>/dev/null
