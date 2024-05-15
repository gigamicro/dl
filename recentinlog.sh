#!/bin/sh
# grep '^\[youtube\] [a-zA-Z0-9_-]\{11\}: Downloading webpage$' /tmp/dl/link/* | \
# sed -e 's/^.*\/\([^/]*\).log:\[youtube\] \([a-zA-Z0-9_-]\{11\}\): Downloading webpage$/https:\/\/youtu.be\/\2 | \1/' -e 's/^https:\/\/youtu.be\///'
# sed 's/[^/]*\///g; s/\.log:/:/; s/: Downloading webpage$//'
# -B 2 -A 6
sleep 6
while [ "$(printf '%s\n' /tmp/dl/link/* | wc -l)" -lt "$(printf '%s\n' /tmp/dl/log/* | wc -l)" ]; do printf '.'; sleep 6; done; echo
echo "Following $1 ($(printf '%s\n' /tmp/dl/link/* | wc -l) files)"
tail "${1+--pid=$1}" -n +1 -f /tmp/dl/link/* 2>&1 | \
grep -a -e '^\[download] Downloading item [0-9]* of [0-9]*$' -e '^ERROR: ' -e '^==> .* <==' | \
sed 'ss^\[download] Downloading item \([0-9]*\) of s\1/s;   ss^==> .*/s==> s;  ss.log <==$s <==s' | \
while read -r i; do
	case $i in
	'==> '*' <==') echo "$i" | head -c -5 |tail -c +5 >/tmp/$$.currentsource ;;
	*'Video unavailable'*) echo ': Video unavailable' | cat /tmp/$$.currentsource - ;;
	*'only available to Music Premium'*) echo ': Premium video' | cat /tmp/$$.currentsource - ;;
	'ERROR: '*) echo ": $i" | cat /tmp/$$.currentsource - ;;
	*/*) echo ": $i" | cat /tmp/$$.currentsource - ;;
	 *) echo "err: '$i'" ;;
	esac
done #| tee /tmp/recentin.log 
rm /tmp/$$.currentsource
