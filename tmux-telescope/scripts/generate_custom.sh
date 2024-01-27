#!/bin/bash

CUSTOM_FILE="$USERDATA_DIR/custom"

echo "Generating custom list..."

if [ ! -f "$CUSTOM_FILE" ]; then
    echo "'$CUSTOM_FILE' not found. Skipping."
    exit 0
fi

file_contents=$(cat "$CUSTOM_FILE")
eval_and_verify_directories "$file_contents"
echo -e "$verified_dirs" > "$SESSIONS_FILE"
