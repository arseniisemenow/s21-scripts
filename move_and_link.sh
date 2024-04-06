#!/bin/bash

move_and_link() {
    local source_dir=$1
    local target_dir=$2
    local link_name=$3

    # Check if the source directory exists
    if [ -d "$source_dir" ]; then
        # Remove the target directory if it exists
        if [ -d "$target_dir/$link_name" ]; then
            rm -rf "$target_dir/$link_name"
        fi

        # Move the source directory to the target directory
        mv "$source_dir" "$target_dir"
    else
        # Create the source directory if it does not exist
        mkdir -p "$source_dir"

        # Remove the target directory if it exists
        if [ -d "$target_dir/$link_name" ]; then
            rm -rf "$target_dir/$link_name"
        fi

        # Move the source directory to the target directory
        mv "$source_dir" "$target_dir"
    fi

    # Create a symbolic link
    ln -s "$target_dir/$link_name" "$source_dir"
}

move_and_link "$1" "$2" "$3"