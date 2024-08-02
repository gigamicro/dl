#!/bin/sh
while [ "$(printf '%s\n' /tmp/dl/link/* | wc -l)" -lt "$(printf '%s\n' /tmp/dl/log/* | wc -l)" ]; do
	printf '%s\r' "$(printf '%s\n' /tmp/dl/link/* | wc -l)/$(printf '%s\n' /tmp/dl/log/* | wc -l)"
	sleep 6
done
