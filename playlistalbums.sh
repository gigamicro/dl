#!/bin/sh
sed 's/ .*//' <~/dl/playlists.m3u | tee /dev/fd/2 | \
while read i; do yt-dlp "$i" --print album | sort | uniq -c | sort -nr && echo ^-"$i" & done
# while read i; do yt-dlp "$i" --print '%(album)s/%(track_number)s' && echo ^-"$i" ; done
