#!/bin/sh
while read -r i; do
	sed -e "/$i$/ s/^#*/#/" -i "$(dirname "$0")/faV.m3u" && \
	rm -v "$(cat "$(dirname "$0")/basedir")/faV/"*" [$i]."*
done
