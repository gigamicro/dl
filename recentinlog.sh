#!/bin/sh
grep '^\[youtube\] [a-zA-Z0-9_-]\{11\}: Downloading webpage$' /tmp/dl/link/* | \
sed -e 's/^.*\/\([^/]*\).log:\[youtube\] \([a-zA-Z0-9_-]\{11\}\): Downloading webpage$/https:\/\/youtu.be\/\2 | \1/' -e 's/^https:\/\/youtu.be\///'
# sed 's/[^/]*\///g; s/\.log:/:/; s/: Downloading webpage$//'
# -B 2 -A 6
