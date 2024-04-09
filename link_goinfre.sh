#!/bin/bash

paths=(
    "$HOME/Library/Containers/com.docker.docker"
    "$HOME/Applications"
    "$HOME/Library/Caches/Google"
    "$HOME/Library/Caches/JetBrains"
    "$HOME/Library/Application Support/Google"
    "$HOME/Library/Application Support/JetBrains"
)

destination="$HOME/goinfre"

# Iterate over each path in the array
for path in "${paths[@]}"; do
    # Execute the move_and_link.sh script for each path
    sh ~/Documents/scripts/move_and_link.sh "$path" "$destination"
done