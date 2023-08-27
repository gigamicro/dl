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
# "$scriptdir/dl.sh" & pid=$!
# tail --pid=$pid -f /tmp/dl/link/* 2>&1 | \
"$scriptdir/dl.sh" &
jobs -p > /tmp/$$.pid
tail --pid="$(head -n 1 /tmp/$$.pid && rm /tmp/$$.pid)" -f /tmp/dl/link/* 2>&1 | \
grep -e '^\[download] Downloading item [0-9]* of [0-9]*$' -e '^==> .* <==' | \
sed 's/^\[download] Downloading item //; ss of s/s; ss^==> .*/s==> s; ss.log <==$s <==s' | \
while read -r i; do
	case $i in
	'==> '*' <==') echo "$i" | head -c -5 |tail -c +5 >/tmp/$$.currentsource ;;
	*/*) echo ": $i" | cat /tmp/$$.currentsource - ;;
	 *) echo "err: '$i'" ;;
	esac
done
rm /tmp/$$.currentsource
echo ===ps===
ps | tail
# echo ===recentinlog===
# "$scriptdir/recentinlog.sh"
echo ===m3ucheck \| toarchive===
"$scriptdir/m3ucheck.sh" | "$scriptdir/toarchive.sh"
if [ "$1" = "z" ]; then
	echo ===archivecheck \| rm===
	"$scriptdir/archivecheck.sh" | xargs -rd \\n rm -v
	echo ===archivecheckstrict \| rm===
	"$scriptdir/archivecheckstrict.sh" | xargs -rd \\n rm -v
	echo ===archiveduplicatecheck \| rm===
	"$scriptdir/archiveduplicatecheck.sh" | xargs -rd \\n rm -v
	# echo '==find -type d -empty -delete=='
	# find "$(cat "$scriptdir/archivedir")" -type d -empty -fprint /dev/stdout -delete
	echo ===cull===
	"$scriptdir/cull.sh" "$(cat "$scriptdir/archivedir")"
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
