#!/bin/sh
ls ~/Music/local/dlarchive/ | grep -o '\-...........\.' | sed 's/^-//; s/\.$//' | while read -r i; do grep "\.$i"<~/Music/dl/faV/faV.m3u; done
