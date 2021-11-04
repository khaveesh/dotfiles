#!/usr/bin/env python3
import json
from pathlib import Path
from shlex import split
from shutil import move, rmtree
from subprocess import PIPE, Popen, run
from typing import Dict, List

colors = {
    "reset": "\033[0m",
    "bold": "\033[01m",
    "red": "\033[31m",
    "green": "\033[32m",
    "cyan": "\033[36m",
    "yellow": "\033[93m",
}


def term(attr: str, msg: str) -> None:
    print(colors[attr] + msg + colors["reset"])


output = (
    run(
        split(
            'nvim --headless --noplugin +"echo json_encode(packages)'
            + " | echo get(g:, 'packdir', stdpath('data'))"
            + ' | q"'
        ),
        stderr=PIPE,
        check=True,
    )
    .stderr.decode()
    .splitlines()
)
packages = json.loads(output[0])

DIR = Path(output[1]) / "site" / "pack" / "packages"
START = DIR / "start"
OPT = DIR / "opt"

for directory in (DIR, START, OPT):
    if not directory.is_dir():
        directory.mkdir(parents=True)


def clean() -> None:
    paths: Dict[str, List[str]] = {"start": [], "opt": []}

    for pack in packages:
        pack_type = pack[1].get("type")
        path = pack[0].split("/")
        paths[pack_type].append(path[1])

    for path in START.iterdir():
        name = path.name
        if name in paths["opt"]:
            term("yellow", f"Moving {name}")
            move(path, OPT / name)
            print()
        elif name not in paths["start"]:
            term("red", f"Removing {name}")
            rmtree(path)
            print()

    for path in OPT.iterdir():
        name = path.name
        if name in paths["start"]:
            term("yellow", f"Moving {name}")
            move(path, START / name)
            print()
        elif name not in paths["opt"]:
            term("red", f"Removing {name}")
            rmtree(path)
            print()


def update_and_install() -> None:
    processes = []

    for pack in packages:
        pack_type = pack[1].get("type")
        path = pack[0].split("/")
        dir_path = DIR / str(pack_type)
        full_path = dir_path / str(path[1])

        if full_path.is_dir():
            processes.append(
                (
                    pack[0],
                    Popen(
                        f"git -C {full_path} fetch --quiet && "
                        + f"git -C {full_path} -P log --pretty=format:'%h %s (%cr)' ..origin/HEAD"
                        + f" && git -C {full_path} pull --quiet",
                        shell=True,
                        stdout=PIPE,
                    ),
                )
            )
        else:
            processes.append(
                (
                    pack[0],
                    Popen(
                        split((f"git -C {dir_path} clone --quiet https://github.com/{pack[0]}.git"))
                    ),
                )
            )

    for proc in processes:
        proc[1].wait()
        term("bold", proc[0])
        if proc[1].stdout:
            if out := proc[1].stdout.read():
                term("cyan", out.decode())
            else:
                print("Already up to date.")
        else:
            term("green", "Installing plugin")
        if proc != processes[-1]:
            print()


if __name__ == "__main__":
    clean()
    update_and_install()
