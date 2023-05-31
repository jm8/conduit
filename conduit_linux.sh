#!/bin/sh
echo -ne '\033c\033]0;conduit\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/conduit_linux.x86_64" "$@"
