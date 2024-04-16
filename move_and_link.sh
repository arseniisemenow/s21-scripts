#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
ORANGE='\033[0;33m'
NC='\033[0m'

move_and_link() {
    local source_dir=$1
    local target_dir=$2

    local source_relative_path=${source_dir#$HOME/}
    local linked_dir_name="linked_$(echo "$source_relative_path" | sed -E 's|/|_|g' | sed -E 's|([a-z])([A-Z])|\1_\2|g' | sed -E 's/(^|_)([a-z])/\U\2/g' | sed -E 's/ /_/g')"

    local dest_dir_name="$linked_dir_name"

    local dest_dir="$target_dir/$dest_dir_name"

    local source_dir_name=$(basename "$source_dir")

    local FINISHED_FLAG=0

    echo "Processing:\ndirectory=[$source_dir]\ntarget_directory=[$target_dir]"

    if [ -L "$source_dir" ]; then
        echo "${GREEN}$source_dir is already a symbolic link.${NC}"

        if ! [ -d "$dest_dir" ]; then
            echo "I wanna create: $(readlink \"$dest_dir\")"
#            mkdir -p "$(readlink \"$source_dir\")"
            mkdir -p "$dest_dir"
            echo "${YELLOW}$(readlink $dest_dir) was not created, It is created now ${NC}"
        fi
        FINISHED_FLAG=1
    elif [ -d "$source_dir" ]; then
        echo "${YELLOW}$source_dir is a directory. I am gonna move it to $target_dir${NC}"
    else
        echo "${YELLOW}$source_dir is not a directory. Creating. I am gonna move it to $target_dir${NC}"
        mkdir -p "$source_dir"
    fi
    if [[ FINISHED_FLAG -eq 0 ]]; then
        echo "Finished flag is not true, I am gonna make move and link"
        if [ -d "$target_dir/$dest_dir_name" ]; then
            # Removing source directory, because we already have such directory in goinfre
            echo "${ORANGE}Removing $source_dir, because it is existed in goinfre already ${NC}"
            rm -r "$source_dir"
        else
            # Moving source directory to the target directory
            echo "${ORANGE}Moving source directory to the target directory${NC}"
            mv "$source_dir" "$target_dir"
            echo "${ORANGE}Renaming source directory after moving to the target directory${NC}"
            # Renaming source directory after moving to the target directory
            mv "$target_dir/$source_dir_name" "$target_dir/$dest_dir_name"
        fi

        # Linking source directory to the target directory
        ln -s "$target_dir/$dest_dir_name" "$source_dir"
    else
        echo "Finished flag is true, I will do nothing from here"
    fi

    echo "Finished processing directory"
}

move_and_link "$1" "$2"