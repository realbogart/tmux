#!/bin/bash

SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")
SCRIPT_DIR=$(cd "$SCRIPT_DIR" && pwd)
TMP_DIR=$SCRIPT_DIR/../tmp
GITREPOS_FILE="$TMP_DIR/gitrepos"

if [ ! -f "$GITREPOS_FILE" ]; then
    "$SCRIPT_DIR/regenerate_gitrepos_list.sh"
fi

selected_repo=$(cat "$GITREPOS_FILE" | fzf)
session_name=$(basename "$selected_repo")

if tmux has-session -t "$session_name" 2>/dev/null; then
    if [ -n "$TMUX" ]; then
        tmux switch-client -t "$session_name"
    else
        tmux attach-session -t "$session_name"
    fi
else
    tmux new-session -d -s "$session_name" -c "$selected_repo"
    if [ -n "$TMUX" ]; then
        tmux switch-client -t "$session_name"
    else
        tmux attach-session -t "$session_name"
    fi
fi

