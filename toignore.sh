#!/bin/sh
exec 2>&1
grep -F "$(basename "$(cat "$(dirname "$0")/basedir")")/" | while read -r i; do
	basename "$i" | sed 's/^.* \[\([a-zA-Z0-9_-]\{11\}\)\]\.[^/]*$/youtube \1/;  s/^.* \[\([0-9]\{10\}\)\]\..*$/soundcloud \1/' | \
	tee -a /dev/fd/2 >>"$(dirname "$0")/ignore/$(basename "$(dirname "$i")").archive" && \
	echo "	\\-> $(dirname "$i").archive" >>/dev/fd/2
done
