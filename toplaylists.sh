#!/bin/sh
xclip -sel p -o | sed 's/www.//; s/music.//; s/watch?v=[^&]*&/playlist?/;a\' >> ~/dl/playlists.m3u
