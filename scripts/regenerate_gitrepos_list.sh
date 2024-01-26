#!/bin/bash

SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")
SCRIPT_DIR=$(cd "$SCRIPT_DIR" && pwd)
RESOURCES_DIR=$SCRIPT_DIR/../resources
TMP_DIR=$SCRIPT_DIR/../tmp

GITROOTS_FILE="$RESOURCES_DIR/gitroots"
GITREPOS_FILE="$TMP_DIR/gitrepos"

default_dir=~

if [ ! -d "$TMP_DIR" ]; then
    mkdir -p "$TMP_DIR"
fi

> $GITREPOS_FILE

find_git_dirs() {
    local dir_path="$1"
    find "$dir_path" -name ".git" | sed 's/\.git$//' >> $GITREPOS_FILE
}

expand_variables() {
    local path="$1"
    eval echo "$path"
}

if [ -f $GITROOTS_FILE ]; then
    while IFS= read -r line
    do
        line=$(expand_variables "$line")

        if [ -d "$line" ]; then
            find_git_dirs "$line"
        else
            echo "Directory $line not found, skipping..."
        fi
    done < $GITROOTS_FILE
else
    echo "$GITROOTS_FILE not found. Defaults to $HOME"
    find_git_dirs "$default_dir"
fi

