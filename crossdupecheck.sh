#!/bin/sh
find "$(cat "$(dirname "$0")/basedir")" -type f ! -name '*.webp' | grep -o ' \[[a-zA-Z0-9_-]*\]\.' | grep -o '[a-zA-Z0-9_-]*' | sort | uniq -d | \
while read -r i; do find "$(cat "$(dirname "$0")/basedir")" -type f -name "* \[${i}].*" ! -name '*.webp'; done
