#!/bin/sh
{
find ~/Music/local/arch/ -type f | grep -o '[[-][a-zA-Z0-9_-]\{11\}[].]' | sed 's/^.//;s/.$//' | sort | uniq -u
find ~/Music/dl/         -type f | grep -o '[[-][a-zA-Z0-9_-]\{11\}[].]' | sed 's/^.//;s/.$//' | sort | uniq -u
} | sort | uniq -d | \
while read -r i; do find ~/Music/local/arch/ -type f -name "*$i*"; done
# while read -r i; do find ~/Music/ -name "*$i*"; done
# | \
# grep Music/local/arch | 
# while read -r i; do mkdir /tmp/musdiscards 2>/dev/null; mv -v "$i" /tmp/musdiscards; done
