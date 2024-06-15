#!/bin/sh
find "$(cat "$(dirname "$0")/basedir")" ! -empty -name '*].*' |
while read i; do {
	ffprobe -show_entries 'stream=width,height' "$i" 2>&- | grep = | tr '\n' ' ' | grep -ve '^ ' -e '^width=\([0-9]*\) height=\1' >/dev/null &&
	printf '%s\n' "$i"
}& sleep 0.00625; done
