#!/bin/sh
for f in *.flac; do echo "$f" "${f/* - /}"; done
