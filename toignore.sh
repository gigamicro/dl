#!/bin/sh
grep -F "$(basename "$(cat "$(dirname "$0")/basedir")")/" | while read -r i; do
	basename "$i" | sed 's/^.* \[\([a-zA-Z0-9_-]\{11\}\)\]\.[^/]*$/youtube \1/' | \
	tee /dev/fd/2 >>"$(dirname "$0")/ignore/$(basename "$(dirname "$i")").archive" && \
	echo "	\\-> $(dirname "$i").archive" >/dev/fd/2
done
