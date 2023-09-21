#!/bin/sh
exec 2>/dev/null
sed 's/ .*//' <"$(dirname "$0")/playlists.m3u" | while read -r i; do
	yt-dlp "$i" --playlist-end 1 --flat-playlist --print 'https://youtube.com/playlist?list=%(playlist_id)s: %(channel)s: %(playlist_title)s'
done
