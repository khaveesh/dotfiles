#!/usr/bin/env python3
import asyncio
from pathlib import Path
from shlex import split
from shutil import move, rmtree

import tomli

DIR = Path("~/.local/share/nvim/site/pack/packages").expanduser()
START = DIR / "start"
OPT = DIR / "opt"
# Create the required directories if they don't exist already
for directory in (START, OPT):
    if not directory.is_dir():
        directory.mkdir(parents=True)


packages = tomli.load(Path("~/.config/nvim/plugins.toml").expanduser().open("rb"))
start_pack = {START / pack.split("/")[1]: pack for pack in packages["start"]}
opt_pack = {OPT / pack.split("/")[1]: pack for pack in packages["opt"]}
map_pack = start_pack | opt_pack


def term(attr: str, msg: str) -> str:
    colors = {
        "reset": "\033[0m",
        "bold": "\033[01m",
        "red": "\033[31m",
        "green": "\033[32m",
        "yellow": "\033[33m",
    }
    return colors[attr] + msg + colors["reset"]


def term_out(attr: str, msg: str) -> None:
    print(term(attr, msg))
    print()


def clean() -> None:
    for directory in frozenset(OPT.iterdir()) & start_pack.keys():
        move(directory, START / directory.name)
        term_out("yellow", f"Moved {directory.name} from opt to start")
    for directory in frozenset(START.iterdir()) & opt_pack.keys():
        move(directory, OPT / directory.name)
        term_out("yellow", f"Moved {directory.name} from start to opt")

    for directory in (frozenset(START.iterdir()) | frozenset(OPT.iterdir())) - map_pack.keys():
        rmtree(directory)
        term_out("red", f"Removed {directory.name}")


async def run_git(pack: str, path: Path) -> str:
    out = term("bold", pack) + "\n"

    if path.is_dir():
        git_pull = await asyncio.create_subprocess_exec(
            *split(f"git -C {path} pull --quiet --ff-only"),
        )
        if await git_pull.wait():
            return out + term("red", "Not a valid git local repo")

        git_log = await asyncio.create_subprocess_exec(
            *split(f"git -C {path} log --pretty=oneline --color --abbrev-commit ORIG_HEAD.."),
            stdout=asyncio.subprocess.PIPE,
        )
        if git_out := (await git_log.communicate())[0]:
            out += git_out.decode().rstrip("\n")
        else:
            out += "Already up to date"
    else:
        git_clone = await asyncio.create_subprocess_exec(
            *split(f"git -C {path.parent} clone --quiet https://github.com/{pack}.git"),
        )
        if await git_clone.wait():
            return out + term("red", "Invalid repo url")
        out += term("green", "Installed")

    return out


async def update_and_install(packs: dict[Path, str]) -> None:
    output = [asyncio.create_task(run_git(packs[pack], pack)) for pack in packs]

    for out in output[:-1]:
        print(await out)
        print()
    print(await output[-1])


if __name__ == "__main__":
    clean()
    asyncio.run(update_and_install(map_pack))
