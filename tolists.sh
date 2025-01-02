#!/bin/sh
sed '
s/www\.//;
ss/$ss;
/youtube\.com/{ s/music\.//; s/watch?v=[^&]*&/playlist?/; s/index=[^&]*&//; }
# /bandcamp\.com/{ s///; }
/soundcloud\.com/{ s/\/tracks$//; }
a\' >> "$(dirname "$0")/$1.m3u"
