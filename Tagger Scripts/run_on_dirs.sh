#!/bin/dash
find . -type d -depth 1 -print0 | xargs -0 -P0 -I{} "$1" {}
