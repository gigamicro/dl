#!/bin/sh
sed 's/ .*//' <~/dl/playlists.m3u | tee /dev/fd/2 | \
while read -r i; do yt-dlp "$i" --playlist-end 1 --flat-playlist --print '%(channel)s: %(playlist_title)s'; done