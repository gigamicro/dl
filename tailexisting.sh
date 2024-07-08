#!/bin/sh
[ -f /tmp/dl.wait.pids ] || exit 0
while read i; do
	if kill -0 "$i" 2>/dev/null; then
		head -n -10 "/proc/$i/fd/1" | head
		echo ...
		tail --pid="$i" -n 1 -f "/proc/$i/fd/1"
	fi
done </tmp/dl.wait.pids
