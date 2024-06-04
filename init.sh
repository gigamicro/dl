#! /bin/sh
scriptdir="$(dirname "$0")"
if [ -e /tmp/dl.lock ]; then echo '/tmp/dl.lock exists'; return 1; fi
touch /tmp/dl.lock
timestamp="$(date +%s)"
echo ===untrash===
"$scriptdir/untrash.sh"
echo ===fromplaylist\|grep archivedir=== #\|rm===
"$scriptdir/fromplaylist.sh" ~/Music/maybe\ remove.m3u | grep -F "$(basename "$(cat "$scriptdir/archivedir")")/"
echo ===fromplaylist\|toignore===
"$scriptdir/fromplaylist.sh" ~/Music/maybe\ remove.m3u | "$scriptdir/toignore.sh"
cat ~/Music/maybe\ remove.m3u 2>&1 1>> ~/Music/maybe\ remove~.m3u && rm ~/Music/maybe\ remove.m3u

echo ===dl\&recentinlog===
"$scriptdir/dl.sh" & "$scriptdir/recentinlog.sh" $!
if [ "$1" = "z" ]; then
	echo ===m3ucheck \| toarchive===
	"$scriptdir/m3ucheck.sh" | "$scriptdir/toarchive.sh"
	echo ===archivecheckstrict \| rm===
	"$scriptdir/archivecheckstrict.sh" | xargs -rd \\n rm -v
	echo ===archivecheck \| rm===
	"$scriptdir/archivecheck.sh" | xargs -rd \\n rm -v
	echo ===archivecheckloose \| rm===
	"$scriptdir/archivecheckloose.sh" | { tee -a /dev/fd/2 >>"$scriptdir/archivecheckloose.log"; } 2>&1 | xargs -rd \\n rm -v
	echo ===archiveduplicatecheck \| rm===
	"$scriptdir/archiveduplicatecheck.sh" | xargs -rd \\n rm -v
	echo ===cull===
	"$scriptdir/cull.sh" "$(cat "$scriptdir/archivedir")"
	echo ===faVduplicatecheck \| fromfaV===
	"$scriptdir/faVduplicatecheck.sh" | grep -o ' \[[a-zA-Z0-9_-]\{11\}\]\.' | cut -c 3-13 | "$scriptdir/fromfaV.sh"
	echo ===covercheck\(missing\) \| toarchive===
	"$scriptdir/covercheck.sh" | grep '^missing' | cut -c 12- | "$scriptdir/toarchive.sh"
else
	echo ===m3ucheck===
	"$scriptdir/m3ucheck.sh"
	echo ===archivecheckstrict===
	"$scriptdir/archivecheckstrict.sh"
	echo ===archivecheck===
	"$scriptdir/archivecheck.sh"
	echo ===archivecheckloose===
	"$scriptdir/archivecheckloose.sh"
	echo ===archiveduplicatecheck===
	"$scriptdir/archiveduplicatecheck.sh"
	echo ===faVduplicatecheck===
	"$scriptdir/faVduplicatecheck.sh"
	echo ===covercheck===
	"$scriptdir/covercheck.sh"
fi
echo ===untouchedcheck===
"$scriptdir/untouchedcheck.sh" "$timestamp"
echo ===crossdupecheck===
"$scriptdir/crossdupecheck.sh"
echo ===duplicatecheck===
"$scriptdir/duplicatecheck.sh"

rm -v /tmp/dl.lock
