#!/bin/bash

# script help block
# multi line

PROG=$(basename "$0")
VERSION="1.0"

# shellcheck source=bash-lib/bash-lib.sh
. bash-lib.sh

ARGS=([FOO]="foo1" [BAR]="" [BAZ]="")
argparse "$@"

msg "$CINFO" "Arguments"
for k in "${!ARGS[@]}"; do echo "$k=${ARGS[$k]}"; done
msg "$CINFO" "Unknown Arguments"
for k in "${!ARGS_REST[@]}"; do echo "$k=${ARGS_REST[$k]}"; done

msg "$(ansi_color fg-yellow underline)" "some text"
echo -e "$(ansi_color fg-cyan bold)another text$(ansi_color reset)"
