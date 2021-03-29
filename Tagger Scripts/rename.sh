#!/bin/dash
for f in *.flac; do echo "$f" "${f/* - /}"; done
