#!/bin/sh
sed 's/www\.//; s/music\.//; s/watch?v=[^&]*&/playlist?/; s/index=[^&]*//; a\' >> "$(dirname "$0")/$1.m3u"
