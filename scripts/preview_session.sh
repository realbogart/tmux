#!/bin/bash

session_name="$1"

if tmux has-session -t "$session_name" 2>/dev/null; then
    tmux capture-pane -pe -t "$session_name"
else
    echo "Session '$session_name' does not exist."
    echo "Select to create it."
fi

