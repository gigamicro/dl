#!/bin/sh
# shellcheck disable=SC1003
faV="$(dirname "$0")"/faV.m3u
# xclip -sel p -o | \
sed 's/^.*?v=\([a-zA-Z0-9_-]\{11\}\).*$/https:\/\/youtu.be\/\1/;a\' > "$faV.tmp"
cat "$faV" >> "$faV.tmp"
cat "$faV.tmp" > "$faV"
rm "$faV.tmp"
