#!/bin/sh
exec sed -e 's/[[\\*?!]/\\&/g' "$@"