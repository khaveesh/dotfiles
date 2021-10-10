#!/usr/bin/env python3
import json
from shlex import split
from subprocess import PIPE, run
from sys import argv, exit

filename = argv[1]
line_no = argv[2]
if filename.startswith("/Users"):
    filename = filename.replace("/Users/khaveesh", "~")

if (
    " kitty"
    not in run(
        split("osascript -e 'tell application \"System Events\" to get name of processes'"),
        stdout=PIPE,
    ).stdout.decode()
):
    run(split("open -a kitty"))

for tab in json.loads(run(split("kitty @ ls"), stdout=PIPE).stdout)[0]["tabs"]:
    for window in tab["windows"]:
        if "NVIM" in window["title"] and filename in window["title"]:
            if not tab["is_focused"]:
                run(split(f'kitty @ focus-tab --match id:{tab["id"]}'))
            if not window["is_focused"]:
                run(split(f'kitty @ focus-window --match id:{window["id"]}'))
            run(split(f'kitty @ send-text "\x1b{line_no}G"'))
            run(split("open -a kitty"))
            exit()

run(split("kitty @ new-window --new-tab"))
run(split(f'kitty @ send-text "nvim +{line_no} {filename}\x0d"'))
run(split("open -a kitty"))
