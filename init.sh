#! /bin/sh
scriptdir="$(dirname "$0")"
"$scriptdir/untrash.sh"
"$scriptdir/toignore.sh"
if [ "$1" = "z" ]; then
	"$scriptdir/covercheck.sh" | while read -r i; do 
		case $i in
		r*) true ;;
		m*) rm -v "${i#*: }" ;;
		 *) echo "covertest err: '$i'" ;;
		esac
	done
fi
"$scriptdir/dl.sh"
"$scriptdir/m3ucheck.sh" | "$scriptdir/toarchive.sh"
if [ "$1" = "z" ]; then
	"$scriptdir/archivecheck.sh" | while read -r i; do rm -v "$i"; done
	"$scriptdir/faVduplicatecheck.sh" | grep -o '\[[a-zA-Z0-9_-]\{11\}\]' | while read -r i; do
		sed -e "/$i$/ s/^#*/#/" -i "$scriptdir/faV.m3u" && rm -v "$(cat "$scriptdir/basedir")/faV/$i"
	done
fi
