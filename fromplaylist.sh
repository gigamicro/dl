#!/bin/sh
[ -f "$1" ] || exit 0
grep -v '^#' "$1"
#maybe remove this
