#!/bin/sh
exec 2>&1
scriptdir="$(dirname "$0")"
grep -F "$(basename "$(cat "$scriptdir/basedir")")/" | while read -r i; do
	dir="$(basename "$(dirname "$i")")"
	basename "$i" | { printf ./;cat; } | "$scriptdir/nametoignores.sh" | \
	tee -a /dev/fd/2 >>"$scriptdir/ignore/$dir.archive" && \
	printf '	\-> %s\n' "$dir.archive" >>/dev/fd/2
done
