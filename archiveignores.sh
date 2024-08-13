#!/bin/sh
scriptdir="$(dirname "$0")"
archivedir="$(cat "$scriptdir/archivedir")"
cat "$scriptdir/ignore/"*".archive" | grep '^[a-z]' | cut -d\  -f2- |
xargs -d \\n -i{} find "$archivedir" -name '* \[{}].*' -o -name '*-{}.*'
