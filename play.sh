#! /bin/bash
# SAVEIFS=$IFS
# IFS=$(echo -en "\n\b")
# for i in $(find . -name '*.opus')
# do
#     ffplay $i -autoexit #-nodisp
# done
# IFS=$SAVEIFS
find . -name "*.opus" | while read i; do ffplay "$i" -autoexit $1; done
