#!/bin/bash

GITROOTS_FILE="$RESOURCES_DIR/gitroots"

echo "Generating Git repository list..."

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

