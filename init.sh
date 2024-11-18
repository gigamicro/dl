#! /bin/sh
exec 2>&1
scriptdir="$(readlink -f -z "$0" | xargs -0 dirname)"
LOCKFILE=/tmp/dl.lock
if [ -e "$LOCKFILE" ]; then printf '%s exists\n' "$LOCKFILE"; return 1; fi
echo $$ > "$LOCKFILE"
timestamp="$(date +%s)"

LOgFILE=/tmp/dl/dl.log
LOhFILE=~/.local/share/dl/"$(date -Is)".log
dirname -z "$LOgFILE" "$LOhFILE" | xargs -0r mkdir -pv
p=$(mktemp -u);mkfifo $p;{
# anything in here has <(our stdout) and >(our old stdout)
tee "$LOgFILE" /dev/fd/2 | stdbuf -oL sed 's/\r$//; s/^.*\r//' > "$LOhFILE"
}<$p&exec>$p;rm $p;p=;
exec 2>&1

echo ===untrash===
"$scriptdir/untrash.sh"
if [ -f ~/Music/maybe\ remove.m3u ]; then
	echo ===fromplaylist\|grep archivedir\|rm===
	grep -v '^#' ~/Music/maybe\ remove.m3u | grep -F "/$(basename "$(cat "$scriptdir/archivedir")")/" | sed 'ss^.*/\([^/]*/[^/]*\)$s\1s' |
		xargs -rd \\n -n 1 printf '%s/%s\n' "$(cat "$scriptdir/archivedir")" | if [ "$1" = "z" ]; then xargs -rd \\n rm -v --; else cat; fi
	echo ===fromplaylist\|toignore===
	grep -v '^#' ~/Music/maybe\ remove.m3u | "$scriptdir/toignore.sh"
	cat ~/Music/maybe\ remove.m3u 2>&1 1>> ~/Music/maybe\ remove~.m3u && rm ~/Music/maybe\ remove.m3u
fi

echo ===dl\&logsummary===; "$scriptdir/dl.sh" & sleep 6;
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
	echo ===archivecheckstrict \| rm===; 		"$scriptdir/archivecheckstrict.sh" | xargs -rd \\n rm -v --
	echo ===archivecheck \| rm===; 				"$scriptdir/archivecheck.sh" | xargs -rd \\n rm -v --
	echo ===archivecheck arch \| rm===; 		"$scriptdir/archivecheck.sh" arch | xargs -rd \\n rm -v --
	echo ===archivecheckloose \| rm===; 		"$scriptdir/archivecheckloose.sh" both | tee -a "$scriptdir/archivecheckloose.log" | xargs -rd \\n rm -v --
	echo ===cull===; 							"$scriptdir/cull.sh" "$(cat "$scriptdir/archivedir")"
else
	grep -Fqx $$ "$LOCKFILE" && rm -v "$LOCKFILE"
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
	echo ===archivecheckloose===; 		"$scriptdir/archivecheckloose.sh" both
fi
echo ===untouchedcheck===; 	"$scriptdir/untouchedcheck.sh" "$timestamp"
# echo ===crossdupecheck===; 	"$scriptdir/crossdupecheck.sh"

[ -f "$LOCKFILE" ] && grep -Fqx $$ "$LOCKFILE" && rm -v "$LOCKFILE"
