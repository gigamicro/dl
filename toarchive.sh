#!/bin/sh
mkdir -v ~/Music/local/arch 2>/dev/null
sed 's/\/home\/gigamicro\/Music\/dl\///' | while read i; do
  mkdir -v ~/Music/local/arch/"${i%/*}" 2>/dev/null
  mv -v ~/Music/dl/"$i" ~/Music/local/arch/"${i%/*}"
done
