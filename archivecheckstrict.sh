#!/bin/sh
{
find "$(cat "$(dirname "$0")/archivedir")" -type f ! -name 'cover.*' ! -name '*.m3u' -print0 | xargs -0 basename -za | sort -z | uniq -z
find "$(cat "$(dirname "$0")/basedir")"    -type f ! -name 'cover.*' ! -name '*.m3u' -print0 | xargs -0 basename -za | sort -z | uniq -z
} | sort -z | uniq -zd | "$(dirname "$0")/unpattern.sh" | xargs -0rn 1 find "$(cat "$(dirname "$0")/archivedir")" -name
