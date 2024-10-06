![Version](https://img.shields.io/badge/version-1.0-brightgreen)
![Bash](https://img.shields.io/badge/Bash-%3E%3D4.0-blue?logo=gnu-bash)
![ShellCheck](https://img.shields.io/badge/linted%20by-ShellCheck-blue)

# bash-lib

Mini Bash Library

## Argument Parsing

It supports `--help`, `--version`, `--key=value` options and `--` separator.

## ANSI Color Support

Converts color description to ANSI code: `fg-green bold` to `\e[032;1m`

## Misc

Also includes:

- file size conversion to K, M or G units
- colored messages
- pre-defined colors `CINFO`, `CWARN`, `CERROR`

## Usage

```bash
#!/bin/bash

# script help block
# multi line
# --foo   help about foo
# --bar   help about bar

PROG=$(basename "$0")
VERSION="1.0"

. bash-lib.sh

ARGS=([FOO]="foo1" [BAR]="" [BAZ]="")
argparse "$@"

msg "$CINFO" "Arguments"
for k in "${!ARGS[@]}"; do echo "$k=${ARGS[$k]}"; done
msg "$CINFO" "Unknown Arguments"
for k in "${!ARGS_REST[@]}"; do echo "$k=${ARGS_REST[$k]}"; done

msg "$(ansi_color fg-yellow underline)" "some text"
echo -e "$(ansi_color fg-cyan bold)another text$(ansi_color reset)"
```
