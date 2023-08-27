#! /bin/sh
scriptdir="$(dirname "$0")"
echo ===untrash===
"$scriptdir/untrash.sh"
echo ===toignore===
"$scriptdir/toignore.sh" ~/Music/maybe\ remove.m3u
# if [ "$1" = "z" ]; then
# echo ===m3ucheck \| toarchive===
# "$scriptdir/m3ucheck.sh" | "$scriptdir/toarchive.sh"
# 	echo ===covercheck \| rm===
# 	"$scriptdir/covercheck.sh" | while read -r i; do
# 		case $i in
# 		r*) rm -v "${i#*: }" "$(dirname ${i#*: })/cover".* ;;
# 		m*) rm -v "${i#*: }" ;;
# 		 *) echo "covertest err: '$i'" ;;
# 		esac
# 	done
# else
# 	echo ===covercheck===
# 	"$scriptdir/covercheck.sh"
# fi
echo ===dl===
"$scriptdir/dl.sh"
echo ===recentinlog===
"$scriptdir/recentinlog.sh"
echo ===m3ucheck \| toarchive===
"$scriptdir/m3ucheck.sh" | "$scriptdir/toarchive.sh"
if [ "$1" = "z" ]; then
	echo ===archivecheck \| rm===
	"$scriptdir/archivecheck.sh" | while read -r i; do rm -v "$i"; done
	find "$(cat "$scriptdir/archivedir")" -type d -empty -fprint /dev/stdout -delete
	"$scriptdir/archivecheckstrict.sh" | xargs -rd \\n rm -v
	echo ===archiveduplicatecheck \| rm===
	"$scriptdir/archiveduplicatecheck.sh" | xargs -rd \\n rm -v
	echo ===faVduplicatecheck \| fromfaV===
	"$scriptdir/faVduplicatecheck.sh" | grep -o ' \[[a-zA-Z0-9_-]\{11\}\]\.' | grep -o '[a-zA-Z0-9_-]\{11\}' | "$scriptdir/fromfaV.sh"
else
	echo ===archivecheck===
	"$scriptdir/archivecheck.sh"
	echo ===archivecheckstrict===
	"$scriptdir/archivecheckstrict.sh"
	echo ===archiveduplicatecheck===
	"$scriptdir/archiveduplicatecheck.sh"
	echo ===faVduplicatecheck===
	"$scriptdir/faVduplicatecheck.sh"
fi
