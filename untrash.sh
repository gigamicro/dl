#! /bin/sh
find "$(cat "$(dirname "$0")/basedir")" "$(cat "$(dirname "$0")/archivedir")" -name '.trashed-??????????-*' | while read -r i; do
	mv -v "$i" "${i%%.trashed-??????????-*}${i#.trashed-??????????-}"
done
