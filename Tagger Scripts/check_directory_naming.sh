#!/bin/dash
fd -t d -d 1 -x dash -c '
f=$(fd -e flac -1 . "{}")
a=$(metaflac --show-tag=Album "$f")
y=$(metaflac --show-tag=ORIGINALYEAR "$f")
b=$(mediainfo "$f" | grep depth)
a=${a#*=}
y=${y#*=}
b=${b#*: }
t="$a [$y]"
# if [ "$b" != "16 bits" ]; then
#     t="$t ($b)"
# fi
if [ "{}" != "$t" ]; then
    echo "{} -> $t"
fi
'
