#!/bin/bash

set -e

if [ -z "$1" ]; then
    url=$(git remote -v | head -n 1 | awk '{print $2}')
else
    url="$1"
fi
echo "Check creds for $url"
creds=$(printf "url=%s\n" "$url" | GIT_TERMINAL_PROMPT=0 git credential fill)
echo "$creds"
