#! /bin/sh
find ~/Music/dl/ -name '.trashed-??????????-*' | while read -r i; do mv -v "$i" "${i%%.trashed-??????????-*}${i#*.trashed-??????????-}"; done
