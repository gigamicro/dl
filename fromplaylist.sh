#!/bin/sh
[ -f "$1" ] || exit 0
grep ' \[[a-zA-Z0-9_-]\{11\}\]\.' "$1"
#maybe remove this
