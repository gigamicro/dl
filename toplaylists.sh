#!/bin/sh
echo "$(xclip -sel p -o | sed 's/www.//; s/music.//; s/watch?v=[^&]*&/playlist?/')" >> ~/dl/playlists.m3u
