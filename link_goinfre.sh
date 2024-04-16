#!/bin/bash

paths=(
#    "$HOME/Applications"
#    "$HOME/Library/Caches/Google"
#    "$HOME/Library/Caches/JetBrains"
#    "$HOME/Library/Caches/Homebrew"
#    "$HOME/Library/Application Support/Google"
#    "$HOME/Library/Application Support/JetBrains"
#    "$HOME/Library/Containers/com.docker.docker"
#    "$HOME/Library/Containers/com.apple.Safari"
#    "$HOME/Library/Java"
    "$HOME/folder_none"
    "$HOME/link_none"
    "$HOME/none_none"
    "$HOME/folder_folder"
    "$HOME/link_folder"
    "$HOME/none_folder"
)

destination="$HOME/goinfre/link_test"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
ORANGE='\033[0;33m'
NC='\033[0m'
FOLDER_NONE=100
LINK_NONE=101
NONE_NONE=102
FOLDER_FOLDER=103
LINK_FOLDER=104
NONE_FOLDER=105
UNKNOWN_UNKNOWN=66

get_case(){
      local source_dir=$1
      local target_dir=$2

      local source_relative_path=${source_dir#$HOME/}
      local linked_dir_name="linked_$(echo "$source_relative_path" | sed -E 's|/|_|g' | sed -E 's|([a-z])([A-Z])|\1_\2|g' | sed -E 's/(^|_)([a-z])/\U\2/g' | sed -E 's/ /_/g')"

      local dest_dir_name="$linked_dir_name"

      local dest_dir="$target_dir/$dest_dir_name"

    echo "source: "$source_dir""
    echo "dest: "$dest_dir""
    if [[ -d "$source_dir" && ! -e $dest_dir ]]; then
      echo "Folder - None"
      return $FOLDER_NONE #100
    elif [[ -L "$source_dir" && ! -e $dest_dir ]]; then
      echo "Link - None"
      return $LINK_NONE #101
    elif [[ ! -d "$source_dir" && ! -e $dest_dir ]]; then
      echo "None - None"
      return $NONE_NONE #102
    elif [[ -d "$source_dir" && -d $dest_dir ]]; then
      echo "Folder - Folder"
      return $FOLDER_FOLDER #103
    elif [[ -L "$source_dir" && -d $dest_dir ]]; then
      echo "Link - Folder"
      return $LINK_FOLDER #104
    elif [[ ! -e "$source_dir" && -d $dest_dir ]]; then
      echo "None - Folder"
      return $NONE_FOLDER #105
    fi



    return $UNKNOWN_UNKNOWN

}

move_and_link() {
    local source_dir=$1
    local target_dir=$2

    local source_relative_path=${source_dir#$HOME/}
    local linked_dir_name="linked_$(echo "$source_relative_path" | sed -E 's|/|_|g' | sed -E 's|([a-z])([A-Z])|\1_\2|g' | sed -E 's/(^|_)([a-z])/\U\2/g' | sed -E 's/ /_/g')"

    local dest_dir_name="$linked_dir_name"

    local dest_dir="$target_dir/$dest_dir_name"

    local source_dir_name=$(basename "$source_dir")
    return 1;

#    local FINISHED_FLAG=0
#
#    if ! [ "$(readlink \"$source_dir\")" == $dest_dir ]; then
#        rm "$source_dir"
#    fi
#
#    if ! [ -d "$source_dir" ]; then
#        mkdir -p "$source_dir"
#    fi
#
#
#    if [[ -d "$target_dir/$dest_dir_name" && -d "$source_dir" ]]; then
#            mv -f "$source_dir" "$target_dir"
#            mv -f "$target_dir/$source_dir_name" "$target_dir/$dest_dir_name"
#        echo
#    fi
#
##    exit 1
#
#    if [ -L "$source_dir" ]; then
##        echo "${GREEN}$source_dir is already a symbolic link.${NC}"
#
#        if ! [ -d "$dest_dir" ]; then
##            echo "I wanna create: $(readlink \"$dest_dir\")"
##            mkdir -p "$(readlink \"$source_dir\")"
#            mkdir -p "$dest_dir"
##            echo "${YELLOW}$(readlink $dest_dir) was not created, It is created now ${NC}"
#        fi
#        FINISHED_FLAG=1
#    elif ! [ -d "$source_dir" ]; then
#        mkdir -p "$source_dir"
##        echo "${YELLOW}$source_dir is not a directory. Creating. I am gonna move it to $target_dir${NC}"
#    fi
#    if [[ FINISHED_FLAG -eq 0 ]]; then
##        echo "Finished flag is not true, I am gonna make move and link"
#        if [[ -d "$target_dir/$dest_dir_name" && -d "$source_dir" ]]; then
#            # Removing source directory, because we already have such directory in goinfre
##            echo "${ORANGE}Removing $source_dir, because it is existed in goinfre already ${NC}"
##            mv "$source_dir" "$target_dir/$dest_dir_name"
##            rm -r "$source_dir"
#            echo
#        else
#            # Moving source directory to the target directory
##            echo "${ORANGE}Moving source directory to the target directory${NC}"
#            mv -f "$source_dir" "$target_dir"
##            echo "${ORANGE}Renaming source directory after moving to the target directory${NC}"
#            # Renaming source directory after moving to the target directory
#            mv -f "$target_dir/$source_dir_name" "$target_dir/$dest_dir_name"
#        fi
#
#        # Linking source directory to the target directory
#        ln -s "$target_dir/$dest_dir_name" "$source_dir"
#    fi
}

let COUNTER=1
let TOTAL_COUNT=${#paths[@]}

mkdir -p "$destination"

for path in "${paths[@]}"; do
#    move_and_link "$path" "$destination"
    get_case "$path" "$destination"
    let RETURN_VALUE=$?
    echo "RETURN_VALUE: $RETURN_VALUE"
    printf "Linked[${GREEN}%d${NC}/%d]: %s\n" $COUNTER $TOTAL_COUNT "$path"
    let COUNTER++
done