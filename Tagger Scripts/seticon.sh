#!/bin/dash
fd -t d -d 1 -x dash -c '
metaflac --export-picture-to="{}"/cover.png "$(fd -e flac -1 . "{}")"
osascript ~/.config/AppleScripts/seticon.applescript "{}/cover.png" "{}"
rm "{}/cover.png"
'
