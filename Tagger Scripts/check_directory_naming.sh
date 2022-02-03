#!/bin/dash
f=$(find "$1" -name '*.flac' -print -quit)
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
if [ "$1" != "./$t" ]; then
    echo "${1#*/} -> $t"
fi
