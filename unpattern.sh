#!/bin/sh
exec sed -e '
s/\\/\\\\/g;
s/\*/\\*/g;
s/\?/\\?/g;
s/\!/\\!/g;
s/\[/\\[/g;
' "$@"
