#!/bin/sh
sleep 6
while [ "$(printf '%s\n' /tmp/dl/link/* | wc -l)" -lt "$(printf '%s\n' /tmp/dl/log/* | wc -l)" ]; do
	printf '%s\r' "$(printf '%s\n' /tmp/dl/link/* | wc -l)/$(printf '%s\n' /tmp/dl/log/* | wc -l)"
	sleep 6
done
echo "Following $1 ($(printf '%s\n' /tmp/dl/link/* | wc -l) files)"
stdbuf -o L tail "${1+--pid=$1}" -n +1 -f /tmp/dl/link/* 2>&1 | \
stdbuf -o L grep -a -e '^\[download] Downloading item [0-9]* of [0-9]*$' -e '^ERROR: ' -e '^==> .* <==' | \
stdbuf -o L sed 'ss^\[download] Downloading item \([0-9]*\) of s\1/s;   ss^==> .*/s==> s;  ss.log <==$s <==s' | \
while read -r i; do
	case $i in
	'==> '*' <==') echo "$i" | head -c -5 |tail -c +5 >/tmp/$$.currentsource ;;
	*'This video contains content from '*', who has blocked it on copyright grounds'*) echo ': Video copystruck' | cat /tmp/$$.currentsource - ;;
	*'[Errno -3] Temporary failure in name resolution'*) echo ": Temporary failure in name resolution" | cat -t /tmp/$$.currentsource - ;;
	*'only available to Music Premium'*) echo ': Premium video' | cat /tmp/$$.currentsource - ;;
	*'This video is not available'*) echo ': Video not available' | cat /tmp/$$.currentsource - ;;
	*'Video unavailable'*) echo ': Video unavailable' | cat /tmp/$$.currentsource - ;;
	'ERROR: '*) echo ": $i" | cat -t /tmp/$$.currentsource - ;;
	*/*) echo ": $i" | cat /tmp/$$.currentsource - ;;
	 *) echo "err: '$i'" ;;
	esac
done #| tee /tmp/recentin.log 
rm /tmp/$$.currentsource
