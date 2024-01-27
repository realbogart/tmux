#!/bin/bash

SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")
SCRIPT_DIR=$(cd "$SCRIPT_DIR" && pwd)
TMP_DIR=$SCRIPT_DIR/../tmp
SESSIONS_FILE="$TMP_DIR/sessions"
PREVIEW_SCRIPT=$SCRIPT_DIR/preview_session.sh

if [ ! -f "$SESSIONS_FILE" ]; then
    "$SCRIPT_DIR/regenerate_sessions_list.sh"
fi

selected_repo=$(cat "$SESSIONS_FILE" | fzf --layout=reverse -i --ansi --preview "$PREVIEW_SCRIPT {}")
session_name=$selected_repo

if [ -z "$selected_repo" ]; then
    exit 0
fi

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

