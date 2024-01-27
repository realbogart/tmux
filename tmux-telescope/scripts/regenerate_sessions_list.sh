#!/bin/bash

SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")
SCRIPT_DIR=$(cd "$SCRIPT_DIR" && pwd)
USERDATA_DIR=$SCRIPT_DIR/../userdata
TMP_DIR=$SCRIPT_DIR/../tmp

SESSIONS_FILE="$TMP_DIR/sessions"

echo "Regenerating sessions list '$SESSIONS_FILE'"

default_dir=~

if [ ! -d "$TMP_DIR" ]; then
    mkdir -p "$TMP_DIR"
fi

> $SESSIONS_FILE

source $SCRIPT_DIR/generate_all.sh

echo "Done!"

