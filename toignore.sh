#!/bin/sh
exec 2>&1
grep -F "$(basename "$(cat "$(dirname "$0")/basedir")")/" | while read -r i; do
	basename "$i" | "$(dirname "$0")/nametoignores.sh" | \
	tee -a /dev/fd/2 >>"$(dirname "$0")/ignore/$(basename "$(dirname "$i")").archive" && \
	echo "	\\-> $(dirname "$i").archive" >>/dev/fd/2
done
