#!/usr/bin/env python3
import argparse
import os
import shutil
import subprocess
import sys
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Setup of dotfiles")
    parser.add_argument(
        "-s",
        "--slurm",
        action="store_true",
        help="Whether to add SLURM aliases and environment variables or not",
    )
    return parser.parse_args()


def main(args: argparse.Namespace) -> None:
    aliases_path = Path("aliases")
    aliases_path.mkdir(exist_ok=True)
    shutil.copy(".base_aliases", aliases_path / ".aliases")

    envs_path = Path("envs")
    envs_path.mkdir(exist_ok=True)
    shutil.copy(".base_envs", envs_path / ".envs")

    shell = input("Shell: [bash] ") or "bash"

    if args.slurm:
        username = input("Username: [gzwei] ") or "gzwei"
        checkpoints = Path(os.path.expanduser(input("Checkpoints directory: ")))

        while not checkpoints.is_dir():
            checkpoints = Path(
                os.path.expanduser(
                    input("Please provide a valid path to your checkpoints directory: ")
                )
            )

        with open(".aliases_template", "r") as f:
            aliases_template = f.read()
        aliases = aliases_template.format(username=username, checkpoints=checkpoints)
        with open(aliases_path / ".aliases", "a") as f:
            f.write(aliases)

        with open(".envs_template", "r") as f:
            envs_template = f.read()
        envs = envs_template.format(checkpoints=checkpoints)
        with open(envs_path / ".envs", "a") as f:
            f.write(envs)

    commands_to_add = ""

    try:
        subprocess.check_call(f"grep -q .aliases ~/.{shell}rc", shell=True)
    except subprocess.CalledProcessError:
        commands_to_add += (
            "\nif [ -f ~/.aliases ]; then\n" "    source ~/.aliases\n" "fi\n"
        )

    try:
        subprocess.check_call(f"grep -q .envs ~/.{shell}rc", shell=True)
    except subprocess.CalledProcessError:
        commands_to_add += "\nif [ -f ~/.envs ]; then\n" "    source ~/.envs\n" "fi\n"

    with open(os.path.expanduser(f"~/.{shell}rc"), "a") as f:
        f.write(commands_to_add)

    print("Done with setup!")
    sys.exit(0)


if __name__ == "__main__":
    args = parse_args()
    main(args)
