#!/bin/sh
echo "Reading $(printf '%s\n' /tmp/dl/link/* | wc -l) files"
stdbuf -o L tail -n +1 ${1+--pid="$1"} ${1+-f} /tmp/dl/link/* | \
stdbuf -o L grep -a -e '^==> .* <==' -e '^Auto cover$' -e '^success:' | \
stdbuf -o L sed 'ss^==> .*/s==> s;  ss.log <==$s <==s' | \
while read -r i; do
	case $i in
	'==> '*' <==') printf '%s' "$i" | head -c -4 | tail -c +5 >/tmp/$$.currentsource ;;
	'Auto cover')printf ': %s\n' "cover.*" | cat /tmp/$$.currentsource - ;;
	'success:'*)printf '/%s\n' "${i#success:}" | cat /tmp/$$.currentsource - ;;
	*) printf 'err: "%s" in log "%s"\n' "$i" "$(cat /tmp/$$.currentsource)";;
	esac
done #| tee /tmp/recentin.log 
rm /tmp/$$.currentsource
