#! /bin/sh
scriptdir="$(dirname "$0")"
echo ===fromplaylist\|grep archivedir=== #\|rm===
"$scriptdir/fromplaylist.sh" ~/Music/maybe\ remove.m3u | grep -F "$(basename "$(cat "$scriptdir/archivedir")")/"
echo ===fromplaylist\|toignore===
"$scriptdir/fromplaylist.sh" ~/Music/maybe\ remove.m3u | "$scriptdir/toignore.sh"
# cat ~/Music/maybe\ remove.m3u 2>&1 1>> ~/Music/maybe\ remove~.m3u && rm ~/Music/maybe\ remove.m3u
