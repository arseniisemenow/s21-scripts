#!/bin/bash

move_and_link() {
    local source_dir=$1
    local target_dir=$2

    local source_relative_path=${source_dir#$HOME/}
    local linked_dir_name="linked_$(echo "$source_relative_path" | sed -E 's|/|_|g' | sed -E 's|([a-z])([A-Z])|\1_\2|g' | sed -E 's/(^|_)([a-z])/\U\2/g' | sed -E 's/ /_/g')"

    local dest_dir_name="$linked_dir_name"

    local dest_dir="$target_dir/$dest_dir_name"

    local source_dir_name=$(basename "$source_dir")

    if [ -d "$source_dir" ]; then
      echo ""
    else
        mkdir -p "$source_dir"
    fi

    # Remove the target directory if it exists
    if [ -d "$dest_dir" ]; then
        rm -rf "$dest_dir"
    fi

    # Moving source directory to the target directory
    mv "$source_dir" "$target_dir"
    # Renaming source directory after moving to the target directory
    mv "$target_dir/$source_dir_name" "$target_dir/$dest_dir_name"

    # Linking source directory to the target directory
    ln -s "$target_dir/$dest_dir_name" "$source_dir"
}

move_and_link "$1" "$2"