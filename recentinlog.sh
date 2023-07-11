#!/bin/sh
grep '^\[youtube\] [a-zA-Z0-9_-]\{11\}: Downloading webpage$' /tmp/dl/link/*
# -B 2 -A 6
