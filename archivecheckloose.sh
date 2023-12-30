#!/bin/sh
{
find "$(cat "$(dirname "$0")/archivedir")" -type f | grep '[[-][a-zA-Z0-9_-]\{11\}[].]' | grep -o '[^/]*/[^/]*$' | grep -v '^faV/' | sed 's/-[a-zA-Z0-9_-]\{11\}\..*$//; s/ \[[a-zA-Z0-9_-]\{11\}\]\..*$//' | sort | uniq
find "$(cat "$(dirname "$0")/basedir")"    -type f | grep   '\[[a-zA-Z0-9_-]\{11\}\]'   | grep -o '[^/]*/[^/]*$' | grep -v '^faV/' | sed 's/ \[[a-zA-Z0-9_-]\{11\}\]\..*$//'  | sort | uniq
} | sort | uniq -d | \
while read -r i; do
	[ 1 -lt "$(
		find "$(cat "$(dirname "$0")/basedir")/${i%/*}" "$(cat "$(dirname "$0")/archivedir")/${i%/*}" \
		-type f -name "${i#*/}[- ][[a-zA-Z0-9_-]??????????[.a-zA-Z0-9_-][]a-zA-Z0-9]*" | \
		xargs -d \\n -n 1 ffprobe 2>&1 | grep -o -e 'Duration: [0-9:]*' -e 'album *: .*'  -e 'artist *: .\{,4\}' | \
		tr '[:upper:]' '[:lower:]' | sort | uniq -u | wc -l #tee /dev/fd/2 | wc -l
	)" ] || \
	#&& echo "$i" #\
	# tail -n +2
	find "$(cat "$(dirname "$0")/archivedir")/${i%/*}" \
		-type f -name "${i#*/}[- ][[a-zA-Z0-9_-]??????????[.a-zA-Z0-9_-][]a-zA-Z0-9]*" #| \
	# mpv --force-window --playlist=-
	# cat;echo
 done #2>&1 | uniq
