#!/bin/sh
# grep '^\[youtube\] [a-zA-Z0-9_-]\{11\}: Downloading webpage$' /tmp/dl/link/* | \
# sed -e 's/^.*\/\([^/]*\).log:\[youtube\] \([a-zA-Z0-9_-]\{11\}\): Downloading webpage$/https:\/\/youtu.be\/\2 | \1/' -e 's/^https:\/\/youtu.be\///'
# sed 's/[^/]*\///g; s/\.log:/:/; s/: Downloading webpage$//'
# -B 2 -A 6
sleep 5
echo "Following $1"
tail --pid="$1" -n +1 -f /tmp/dl/link/* 2>&1 | \
grep -e '^\[download] Downloading item [0-9]* of [0-9]*$' -e '^ERROR: ' -e '^==> .* <==' | \
# grep -v -e 'not available' -e 'only available' | \
sed 's/^\[download] Downloading item //; ss of s/s; ss^==> .*/s==> s; ss.log <==$s <==s' | \
while read -r i; do
	case $i in
	'==> '*' <==') echo "$i" | head -c -5 |tail -c +5 >/tmp/$$.currentsource ;;
	*'Video unavailable'*) echo ': Video unavailable' | cat /tmp/$$.currentsource - ;;
	*'only available to Music Premium'*) echo ': Premium video' | cat /tmp/$$.currentsource - ;;
	'ERROR: '*) echo ": $i" | cat /tmp/$$.currentsource - ;;
	*/*) echo ": $i" | cat /tmp/$$.currentsource - ;;
	 *) echo "err: '$i'" ;;
	esac
done
rm /tmp/$$.currentsource
