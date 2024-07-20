#!/bin/sh
# 1: search dir
# 2: exclude/find subdir
[ -n "$2" ] || exit 0
dir="${1:-$(cat "$(dirname "$0")/basedir")}"
find "$dir" \( ! -name "$2" -o -prune \) -type f ! -name '*.webp' | \
grep -o '[^[]*$' | #sort | { [ -n "$2" ] && uniq || uniq -d; } | \
xargs -d\\n -i{} find "$dir/$2" -type f -name '* \[{}' ! -name '*.webp'
