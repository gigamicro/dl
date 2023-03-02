#!/bin/sh
mkdir /tmp/dltesting
cd /tmp/dltesting
touch q; rm ./*
ls ~/Music/dl/faV/ | while read i; do touch "$i"; done
rm *.m3u
cat ~/Music/dl/faV/faV.m3u | grep '].' | while read i; do rm "$i"; done
ls
rm -r /tmp/dltesting
