#!/bin/sh
# shellcheck disable=SC1003
# xclip -sel p -o | \
sed 's/www.//; s/music.//; s/watch?v=[^&]*&/playlist?/;a\' >> ~/dl/playlists.m3u
