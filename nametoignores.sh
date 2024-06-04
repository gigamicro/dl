#!/bin/sh
sed '
s/^.* \[\([0-9a-zA-Z_-]\{11\}\)\]\..*$/youtube \1\n&/;
s/^.* \[\([0-9]\{10\}\)\]\..*$/soundcloud \1\n&/;
s/^.* \[\([0-9]*\)\]\..*$/bandcamp \1\n&/;
' | grep -ve '^\.'
