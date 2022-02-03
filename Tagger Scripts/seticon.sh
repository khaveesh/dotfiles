#!/bin/dash
metaflac --export-picture-to="$1"/cover.png "$(find "$1" -name '*.flac' -print -quit)"
osascript ~/Music/seticon.applescript "$1/cover.png" "$1"
rm "$1/cover.png"
