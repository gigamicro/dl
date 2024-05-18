#!/bin/sh
timestamp="${1:-$(date -d '-1 hour' +%s)}"
find "$(cat "$(dirname "$0")/basedir")" -name '*.m3u' -mmin "+$(dc -e"$(date +%s) $timestamp -60/p")"
