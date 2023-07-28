#!/bin/sh
sed 's/ .*//' <"$(dirname "$0")/playlists.m3u" | \
while read -r i; do yt-dlp "$i" --print album | sort | uniq -c | sort -nr && echo ^-"$i" & done
# while read i; do yt-dlp "$i" --print '%(album)s/%(track_number)s' && echo ^-"$i" ; done
