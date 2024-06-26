#! /bin/sh
scriptdir="$(dirname "$0")"
exec 2>&1
if [ -e /tmp/dl.lock ]; then echo '/tmp/dl.lock exists'; return 1; fi
touch /tmp/dl.lock
timestamp="$(date +%s)"
echo ===untrash===
"$scriptdir/untrash.sh"
if [ -f ~/Music/maybe\ remove.m3u ]; then
	if [ "$1" = "z" ]; then
		echo ===fromplaylist\|grep archivedir\|rm===
		grep -v '^#' ~/Music/maybe\ remove.m3u | grep -F "/$(basename "$(cat "$scriptdir/archivedir")")/" | sed 'ss^.*/\([^/]*/[^/]*\)$s\1s' |
			xargs -rd \\n -n 1 printf '%s/%s\n' "$(cat "$scriptdir/archivedir")" | xargs -rd \\n rm -v --
	else
		echo ===fromplaylist\|grep archivedir===
		grep -v '^#' ~/Music/maybe\ remove.m3u | grep -F "/$(basename "$(cat "$scriptdir/archivedir")")/" | sed 'ss^.*/\([^/]*/[^/]*\)$s\1s' |
			xargs -rd \\n -n 1 printf '%s/%s\n' "$(cat "$scriptdir/archivedir")"
	fi
	echo ===fromplaylist\|toignore===
	grep -v '^#' ~/Music/maybe\ remove.m3u | "$scriptdir/toignore.sh"
	cat ~/Music/maybe\ remove.m3u 2>&1 1>> ~/Music/maybe\ remove~.m3u && rm ~/Music/maybe\ remove.m3u
fi

echo ===dl\&recentinlog===
"$scriptdir/dl.sh" & sleep 6;"$scriptdir/recentinlog.sh" $!
if [ "$1" = "z" ]; then
	echo ===faVduplicatecheck \| fromfaV===; 		"$scriptdir/faVduplicatecheck.sh" | "$scriptdir/nametoignores.sh" | cut -d\  -f2- | "$scriptdir/fromfaV.sh"
	echo ===archivecheckstrict \| rm===; 			"$scriptdir/archivecheckstrict.sh" | xargs -rd \\n rm -v --
	echo ===archivecheck \| rm===; 					"$scriptdir/archivecheck.sh" | xargs -rd \\n rm -v --
	echo ===archivecheckloose \| rm===; 			"$scriptdir/archivecheckloose.sh" | tee -a "$scriptdir/archivecheckloose.log" | xargs -rd \\n rm -v --
	echo ===m3ucheck \| toarchive===; 				"$scriptdir/m3ucheck.sh" | "$scriptdir/toarchive.sh"
	echo ===covercheck\(missing\) \| toarchive===; 	"$scriptdir/covercheck.sh" | grep '^missing' | cut -c 12- | "$scriptdir/toarchive.sh"
	echo ===squarecheck \| toarchive===; 			"$scriptdir/squarecheck.sh" | "$scriptdir/toarchive.sh"
	echo ===duplicatecheck \| toarchive===; 		"$scriptdir/duplicatecheck.sh" | "$scriptdir/toarchive.sh"
	echo ===archiveduplicatecheck \| rm===; 		"$scriptdir/archiveduplicatecheck.sh" | xargs -rd \\n rm -v --
	echo ===cull===; 								"$scriptdir/cull.sh" "$(cat "$scriptdir/archivedir")"
else
	echo ===faVduplicatecheck===; 		"$scriptdir/faVduplicatecheck.sh"
	echo ===archivecheckstrict===; 		"$scriptdir/archivecheckstrict.sh"
	echo ===archivecheck===; 			"$scriptdir/archivecheck.sh"
	echo ===archivecheckloose===; 		"$scriptdir/archivecheckloose.sh"
	echo ===m3ucheck===; 				"$scriptdir/m3ucheck.sh"
	echo ===covercheck===; 				"$scriptdir/covercheck.sh"
	echo ===squarecheck===; 			"$scriptdir/squarecheck.sh"
	echo ===duplicatecheck===; 			"$scriptdir/duplicatecheck.sh"
	echo ===archiveduplicatecheck===; 	"$scriptdir/archiveduplicatecheck.sh"
fi
echo ===untouchedcheck===; 	"$scriptdir/untouchedcheck.sh" "$timestamp"
# echo ===crossdupecheck===; 	"$scriptdir/crossdupecheck.sh"

rm -v /tmp/dl.lock
