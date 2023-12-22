#!/bin/sh
# Self-installing wrapper script for Digestif

set -eu

################################################################################
# Change the line below to install in a different location
DIGESTIF_HOME="$HOME/.digestif"
# Git repo from which to fetch Digestif
DIGESTIF_REPO="https://github.com/astoff/digestif"
# Name of the Lua interpreter to use
LUA=texlua
################################################################################

if [ ! -r "$DIGESTIF_HOME/bin/digestif" ]; then
    echo >&2 "Digestif not found in $DIGESTIF_HOME, fetching it now"
    mkdir -p "$DIGESTIF_HOME"
    git clone --depth 1 "$DIGESTIF_REPO" "$DIGESTIF_HOME"
    echo >&2 "Done! If you are running this interactively, press Control-C to quit."
fi

export LUA_PATH="$DIGESTIF_HOME/?.lua"
export DIGESTIF_PRERELEASE="$(git -C "$DIGESTIF_HOME" rev-parse --short HEAD)"
exec "$LUA" "$DIGESTIF_HOME/bin/digestif" "$@"
