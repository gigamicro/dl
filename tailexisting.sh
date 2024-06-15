#!/bin/sh
[ -f /tmp/dl.wait.pids ] || exit 0
while read i; do
	if kill -0 "$i" 2>/dev/null; then
		head "/proc/$i/fd/1"
		echo ...
		tail --pid="$i" -n 1 -f "/proc/$i/fd/1"
	fi
done </tmp/dl.wait.pids
