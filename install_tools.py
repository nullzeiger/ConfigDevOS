#!/usr/bin/env python3
from __future__ import annotations
import subprocess
from pathlib import Path
import sys


def main() -> None:
    packages = ["gcc", "gdb", "make", "valgrind", "curl", "git"]
    install_packages_apt(packages)

    print("Package installation complete.")

    run_install_scripts()


def install_packages_apt(packages: list[str]) -> None:
    cmd = ["sudo", "apt", "update"]
    run_command(cmd)

    cmd = ["sudo", "apt", "install", "-y", *packages]
    run_command(cmd)


def run_install_scripts() -> None:
    scripts = [
        "install_kitty.sh",
        "install_nvim.sh",
        "install_go.sh",
    ]

    for script in scripts:
        print(f"Running {script}...")

        script_path = Path(script)
        if not script_path.exists():
            sys.exit(f"Error: script not found: {script}")

        run_command(["bash", str(script_path)], error_message=f"Error running {script}")


def run_command(cmd: list[str], error_message: str | None = None) -> None:
    error_message = error_message or "Error executing command"

    print(f"Executing: {' '.join(cmd)}")
    try:
        subprocess.run(cmd, check=True)
    except subprocess.CalledProcessError as e:
        sys.exit(f"{error_message}: exit code {e.returncode}")


if __name__ == "__main__":
    main()

