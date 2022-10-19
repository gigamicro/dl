#! /bin/sh
mkdir /tmp/dltesting; cd /tmp/dltesting; touch q; rm ./*; ls ~/dl/dl/ | while read i; do touch "$i"; done; rm dl.m3u; cat ~/dl/dl/dl.m3u | while read i; do rm "$i"; done; ls|cat; rm -r /tmp/dltesting
