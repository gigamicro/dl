#!/bin/sh
sed 's/\/home\/gigamicro\/Music\/dl\///' | while read i; do
  mkdir -v ~/Music/local/arch/"${i%/*}"
  mv -v ~/Music/dl/"$i" ~/Music/local/arch/"${i%/*}"
done
