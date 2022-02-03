#!/usr/bin/env python3
from multiprocessing import Pool
from pathlib import Path
from shlex import split
from shutil import move, rmtree
from subprocess import PIPE, run
from typing import Dict, List

import tomli

colors = {
    "reset": "\033[0m",
    "bold": "\033[01m",
    "red": "\033[31m",
    "green": "\033[32m",
    "cyan": "\033[36m",
    "yellow": "\033[93m",
}


def term_out(attr: str, msg: str) -> None:
    print(colors[attr] + msg + colors["reset"])
    print()


def term(attr: str, msg: str) -> str:
    return colors[attr] + msg + colors["reset"]


packages = tomli.load(Path("~/.config/nvim/plugins.toml").expanduser().open(encoding="utf-8"))

DIR = Path("~/.local/share/nvim/site/pack/packages").expanduser()
START = DIR / "start"
OPT = DIR / "opt"

for directory in (START, OPT):
    if not directory.is_dir():
        directory.mkdir(parents=True)

map_pack = []
paths: Dict = {"start": [], "opt": []}
for pack in packages["start"]:
    name = pack.split("/")[1]
    paths["start"].append(name)
    map_pack.append([pack, START / name])
for pack in packages["opt"]:
    name = pack.split("/")[1]
    paths["opt"].append(name)
    map_pack.append([pack, OPT / name])


def clean() -> None:
    start_dir = {p.name for p in START.iterdir()}
    opt_dir = {p.name for p in OPT.iterdir()}

    for directory in opt_dir & set(paths["start"]):
        move(OPT / directory, START / directory)
        term_out("yellow", f"Moved {directory}")
    for directory in start_dir & set(paths["opt"]):
        move(START / directory, OPT / directory)
        term_out("yellow", f"Moved {directory}")

    start_dir = {p.name for p in START.iterdir()}
    opt_dir = {p.name for p in OPT.iterdir()}

    for directory in start_dir - set(paths["start"]):
        rmtree(START / directory)
        term_out("red", f"Removed {directory}")
    for directory in opt_dir - set(paths["opt"]):
        rmtree(OPT / directory)
        term_out("red", f"Removed {directory}")


def update_and_install(pack: List) -> str:
    out = term("bold", pack[0]) + "\n"

    if pack[1].is_dir():
        run(split(f"git -C {pack[1]} pull --quiet --ff-only"), check=True)
        git_out = run(
            split(f"git -C {pack[1]} log --pretty=oneline --color --abbrev-commit ORIG_HEAD.."),
            stdout=PIPE,
            check=True,
        ).stdout
        if git_out:
            out += git_out.decode().rstrip("\n")
        else:
            out += "Already up to date"
    else:
        run(
            split((f"git -C {pack[1].parent} clone --quiet https://github.com/{pack[0]}.git")),
            check=True,
        )
        out += term("green", "Installed")

    return out


if __name__ == "__main__":
    clean()
    with Pool() as p:
        out = p.map(update_and_install, map_pack)
    for o in out[:-1]:
        print(o)
        print()
    print(out[-1])
