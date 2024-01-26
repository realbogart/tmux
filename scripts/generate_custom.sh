#!/bin/bash

CUSTOM_FILE="$RESOURCES_DIR/custom"

echo "Generating custom list..."

expand_variables() {
    local path="$1"
    eval echo "$path"
}

if [ -f $CUSTOM_FILE ]; then
    while IFS= read -r line
    do
        line=$(expand_variables "$line")

        if [ -d "$line" ]; then
            echo $line >> $SESSIONS_FILE
        else
            echo "Directory $line not found, skipping..."
        fi
    done < $CUSTOM_FILE
fi

