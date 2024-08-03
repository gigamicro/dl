#! /bin/sh
exec 2>&1
scriptdir="$(dirname "$0")"
LOCKFILE=/tmp/dl.lock
if [ -e "$LOCKFILE" ]; then printf '%s exists\n' "$LOCKFILE"; return 1; fi
echo $$ > "$LOCKFILE"
timestamp="$(date +%s)"

echo ===untrash===
"$scriptdir/untrash.sh"
if [ -f ~/Music/maybe\ remove.m3u ]; then
	echo ===fromplaylist\|grep archivedir\|rm===
	grep -v '^#' ~/Music/maybe\ remove.m3u | grep -F "/$(basename "$(cat "$scriptdir/archivedir")")/" | sed 'ss^.*/\([^/]*/[^/]*\)$s\1s' |
		xargs -rd \\n -n 1 printf '%s/%s\n' "$(cat "$scriptdir/archivedir")" | { [ "$1" = "z" ] && cat || xargs -rd \\n rm -v --; }
	echo ===fromplaylist\|toignore===
	grep -v '^#' ~/Music/maybe\ remove.m3u | "$scriptdir/toignore.sh"
	cat ~/Music/maybe\ remove.m3u 2>&1 1>> ~/Music/maybe\ remove~.m3u && rm ~/Music/maybe\ remove.m3u
fi

echo ===dl\&recentinlog===; "$scriptdir/dl.sh" & sleep 6;
"$scriptdir/waitforlogs.sh";
# "$scriptdir/recentinlog.sh" $!;
"$scriptdir/logsummary.sh" $!;
wait $!
if [ "$1" = "z" ]; then
	echo ===duplicatem3ucheck/s===; 			"$scriptdir/duplicatem3ucheck.sh" "$(cat "$scriptdir/basedir")"/'faV' | "$scriptdir/nametoignores.sh" | cut -d\  -f2- | "$scriptdir/fromfaV.sh"
	echo ===m3ucheck \| toarchive===; 			"$scriptdir/m3ucheck.sh" | "$scriptdir/toarchive.sh"
	echo ===duplicatecheck \| toarchive===; 	"$scriptdir/duplicatecheck.sh" | "$scriptdir/toarchive.sh"
	echo ===covercheck\(missing\|nonsquare\) \| toarchive===;"$scriptdir/covercheck.sh"|grep -e '^missing' -e '^nonsquare'|cut -c12-|"$scriptdir/toarchive.sh"
	echo ===archcrossdupecheck/s===; 			"$scriptdir/crossdupecheck.sh" "$(cat "$scriptdir/archivedir")" .misc | xargs -rd \\n rm -v --
	echo ===archiveignores \| rm===; 			"$scriptdir/archiveignores.sh" | xargs -rd \\n rm -v --
	echo ===archivecheckstrict \| rm===; 		{ "$scriptdir/archivecheckstrict.sh" | xargs -rd \\n rm -v --; } 2>&1
	echo ===archivecheck \| rm===; 				"$scriptdir/archivecheck.sh" | xargs -rd \\n rm -v --
	echo ===archivecheck arch \| rm===; 		"$scriptdir/archivecheck.sh" arch | xargs -rd \\n rm -v --
	echo ===archivecheckloose \| rm===; 		{ "$scriptdir/archivecheckloose.sh" | tee -a "$scriptdir/archivecheckloose.log" | xargs -rd \\n rm -v --; } 2>&1
	echo ===archivecheckloose arch \| rm===; 	{ "$scriptdir/archivecheckloose.sh" arch | tee -a "$scriptdir/archivecheckloose.log" | xargs -rd \\n rm -v --; } 2>&1
	echo ===cull===; 							"$scriptdir/cull.sh" "$(cat "$scriptdir/archivedir")"
else
	grep -Fqm1 $$ "$LOCKFILE" && rm -v "$LOCKFILE"
	echo ===duplicatem3ucheck/s===; 	"$scriptdir/duplicatem3ucheck.sh" "$(cat "$scriptdir/basedir")"/'faV'
	                                	"$scriptdir/duplicatem3ucheck.sh" "$(cat "$scriptdir/basedir")"/'Danger'
	                                	"$scriptdir/duplicatem3ucheck.sh" "$(cat "$scriptdir/basedir")"/'Carpenter Brut'
	echo ===m3ucheck===; 				"$scriptdir/m3ucheck.sh"
	echo ===duplicatecheck===; 			"$scriptdir/duplicatecheck.sh"
	echo ===crossdupecheck/s===; 		"$scriptdir/crossdupecheck.sh" "$(cat "$scriptdir/archivedir")" .misc
	echo ===covercheck===; 				"$scriptdir/covercheck.sh"
	echo ===archiveignores===; 			"$scriptdir/archiveignores.sh"
	echo ===archivecheckstrict===; 		"$scriptdir/archivecheckstrict.sh"
	echo ===archivecheck===; 			"$scriptdir/archivecheck.sh"
	echo ===archivecheck arch===; 		"$scriptdir/archivecheck.sh" arch
	echo ===archivecheckloose===; 		"$scriptdir/archivecheckloose.sh"
	echo ===archivecheckloose arch===; 	"$scriptdir/archivecheckloose.sh" arch
fi
echo ===untouchedcheck===; 	"$scriptdir/untouchedcheck.sh" "$timestamp"
# echo ===crossdupecheck===; 	"$scriptdir/crossdupecheck.sh"

[ -f "$LOCKFILE" ] && grep -Fqm1 $$ "$LOCKFILE" && rm -v "$LOCKFILE"
