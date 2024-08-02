#!/bin/sh
for f in /tmp/dl/log/*; do grep -qm 1 ' -> '\''\.\.' "$f" || printf '%s\n' "$f"; done
