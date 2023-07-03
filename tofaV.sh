#!/bin/sh
xclip -sel p -o | sed 's/^.*?v=\([a-zA-Z0-9_-]\{11\}\).*$/https:\/\/youtu.be\/\1/;a\' > ~/dl/faV.m3u.tmp
cat ~/dl/faV.m3u >> ~/dl/faV.m3u.tmp
cat ~/dl/faV.m3u.tmp > ~/dl/faV.m3u
rm ~/dl/faV.m3u.tmp
