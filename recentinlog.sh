#!/bin/sh
echo "Following $1 ($(printf '%s\n' /tmp/dl/link/* | wc -l) files)"
stdbuf -o L tail "${1+--pid=$1}" -n +1 -f /tmp/dl/link/* 2>&1 | \
stdbuf -o L grep -a -e '^\[download] Downloading item [0-9]* of [0-9]*$' -e '^ERROR: ' -e '^\[download] Got error:' \
	-e '^==> .* <==' -e '^Writing playlist$' -e '^├────────────────┤' -e '^success:' | \
stdbuf -o L sed 'ss^\[download] Downloading item \([0-9]*\) of s\1/s;   ss^==> .*/s==> s;  ss.log <==$s <==s' | \
while read -r i; do
	case $i in
	'==> '*' <==') printf '%s' "$i" | head -c -4 | tail -c +5 >/tmp/$$.currentsource ;;
	*'This video contains content from '*', who has blocked it on copyright grounds'*) echo ': Video copystruck' | cat /tmp/$$.currentsource - ;;
	*'[Errno -3] Temporary failure in name resolution'*) echo ": Temporary failure in name resolution" | cat -t /tmp/$$.currentsource - ;;
	'[download] Got error: HTTP Error 500'*) printf ': HTTP 500 Internal Server Error (%s\n' "${i##*(}" | cat -t /tmp/$$.currentsource - ;;
	'[download] Got error: HTTP Error 429'*) printf ': HTTP 429: Too Many Requests f.%s\n' "${i##*fragment }" | cat -t /tmp/$$.currentsource - ;;
	'ERROR: '*': '*' said: The playlist'*) printf ': Playlist %s\n' "${i##*The playlist }" | cat -t /tmp/$$.currentsource - ;;
	*'only available to Music Premium'*) echo ': Premium video' | cat /tmp/$$.currentsource - ;;
	*'This video is not available'*) echo ': Video not available' | cat /tmp/$$.currentsource - ;;
	*'Private video. Sign in'*) echo ': Private video' | cat /tmp/$$.currentsource - ;;
	'[download] Got error:'*) printf ':%s\n' "${i#\[download]}" | cat -t /tmp/$$.currentsource - ;;
	*'Video unavailable'*) echo ': Video unavailable' | cat /tmp/$$.currentsource - ;;
	*': HTTP Error 404'*)printf ': HTTP 404: Not Found, %s\n' "${i%%: HTTP Error 404*}" | sed 's/ ERROR: \[.*]//' | cat -t /tmp/$$.currentsource - ;;
	├────────────────┤*) echo ': Done' | cat /tmp/$$.currentsource - ;;
	'Writing playlist')printf ': %s\n' "$i" | cat /tmp/$$.currentsource - ;;
	'success:'*)printf ': %s\n' "${i#success:}" | cat -t /tmp/$$.currentsource - ;;
	'ERROR: '*) printf ': %s\n' "$i" | cat -t | cat /tmp/$$.currentsource - ;;
	*/*) printf ': %s\n' "$i" | cat /tmp/$$.currentsource - ;;
	*) printf 'err: "%s" in log "%s"\n' "$i" "$(cat /tmp/$$.currentsource)";;
	esac
done #| tee /tmp/recentin.log 
rm /tmp/$$.currentsource
