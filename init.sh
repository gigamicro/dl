#! /bin/sh
scriptdir="$(dirname "$0")"
echo ===untrash===
"$scriptdir/untrash.sh"
echo ===toignore===
"$scriptdir/toignore.sh"
if [ "$1" = "z" ]; then
	echo ===covercheck===
	"$scriptdir/covercheck.sh" | while read -r i; do
		case $i in
		r*) true ;;
		m*) rm -v "${i#*: }" ;;
		 *) echo "covertest err: '$i'" ;;
		esac
	done
fi
echo ===dl===
"$scriptdir/dl.sh"
echo ===m3ucheck===
"$scriptdir/m3ucheck.sh" | "$scriptdir/toarchive.sh"
if [ "$1" = "z" ]; then
	echo ===archivecheck===
	"$scriptdir/archivecheck.sh" | while read -r i; do rm -v "$i"; done
	echo ===faVduplicatecheck===
	"$scriptdir/faVduplicatecheck.sh" | grep -o '\[[a-zA-Z0-9_-]\{11\}\]' | while read -r i; do
		sed -e "/$i$/ s/^#*/#/" -i "$scriptdir/faV.m3u" && rm -v "$(cat "$scriptdir/basedir")/faV/$i"
	done
fi
