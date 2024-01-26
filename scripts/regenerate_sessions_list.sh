#!/bin/bash

SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")
SCRIPT_DIR=$(cd "$SCRIPT_DIR" && pwd)
RESOURCES_DIR=$SCRIPT_DIR/../resources
TMP_DIR=$SCRIPT_DIR/../tmp

GITROOTS_FILE="$RESOURCES_DIR/gitroots"
SESSIONS_FILE="$TMP_DIR/sessions"

echo "Regenerating Git repository list '$SESSIONS_FILE'"

default_dir=~

if [ ! -d "$TMP_DIR" ]; then
    mkdir -p "$TMP_DIR"
fi

> $SESSIONS_FILE

find_git_dirs() {
    local dir_path="$1"
    find "$dir_path" -name ".git" | sed 's/\.git$//' >> $SESSIONS_FILE
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

echo "Done!"

