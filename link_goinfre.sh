#!/bin/bash

paths=(
    "$HOME/Library/Containers/com.docker.docker"
    "$HOME/Applications"
    "$HOME/Library/Caches/Google"
    "$HOME/Library/Caches/JetBrains"
    "$HOME/Library/Application Support/Google"
    "$HOME/Library/Application Support/JetBrains"
    "$HOME/Library/Java"
    "$HOME/Library/Caches/Homebrew"
)

destination="$HOME/goinfre"

for path in "${paths[@]}"; do
    sh ~/Documents/scripts/move_and_link.sh "$path" "$destination"
done