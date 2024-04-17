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
#    "$HOME/folder_none"
#    "$HOME/link_none"
    "$HOME/none_none"
#    "$HOME/folder_folder"
#    "$HOME/link_folder"
#    "$HOME/none_folder"
)

destination="$HOME/goinfre/link_test"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
ORANGE='\033[0;33m'
NC='\033[0m'

# Here described codes for all possible binary cases, assuming we have three states of abstract item: Folder, Link, None
FOLDER_FOLDER=100 # Done
FOLDER_LINK=101 # Unreal
FOLDER_NONE=102 # Done
LINK_FOLDER=103 # Done
LINK_LINK=104 # Unreal
LINK_NONE=105 # Done
NONE_FOLDER=106 # Done
NONE_LINK=107 # Unreal
NONE_NONE=108 # Done
UNKNOWN_UNKNOWN=66

get_case(){
    local source_path_dir=$1
    local target_path=$2

    local source_relative_path
    source_relative_path=$(basename "$source_path_dir")

    local target_dir_name
    target_dir_name=$(get_linked_name "$source_path_dir")

    local target_dir_name="$target_dir_name"

    local target_path_dir="$target_path/$target_dir_name"

    if [[ -L "$source_path_dir" && -d $target_path_dir ]]; then
      echo "Link - Folder"
      return $LINK_FOLDER
    elif [[ -L "$source_path_dir" && -L $target_path_dir ]]; then
      echo "Link - Link"
      return $LINK_LINK
    elif [[ -L "$source_path_dir" && ! -e $target_path_dir ]]; then
      echo "Link - None"
      return $LINK_NONE
    elif [[ -d "$source_path_dir" && -d $target_path_dir ]]; then
      echo "Folder - Folder"
      return $FOLDER_FOLDER
    elif [[ -d "$source_path_dir" && -L $target_path_dir ]]; then
      echo "Folder - Link"
      return $FOLDER_LINK
    elif [[ -d "$source_path_dir" && ! -e $target_path_dir ]]; then
      echo "Folder - None"
      return $FOLDER_NONE
    elif [[ ! -e "$source_path_dir" && -d $target_path_dir ]]; then
      echo "None - Folder"
      return $NONE_FOLDER
    elif [[ ! -e "$source_path_dir" && -L $target_path_dir ]]; then
      echo "None - Link"
      return $NONE_LINK
    elif [[ ! -e "$source_path_dir" && ! -e $target_path_dir ]]; then
      echo "None - None"
      return $NONE_NONE
    fi

    return $UNKNOWN_UNKNOWN
}

handle_folder_folder(){
  local source_path=$1
  local source_dir_name=$2
  local target_path=$3
  local target_dir_name=$4
  local error_code=0

  # Removing target directory
  rm -rf "${target_path:?}/${target_dir_name}"
  # ^           ^           ^           ^
  # |           |           |           |
  # Optional moment: You can chooses what directory is more
  # important for you. By default more important is source directory

  handle_folder_none $source_path $source_dir_name $target_path $target_dir_name
  error_code=$?

  return $error_code
}
handle_folder_link(){
  # Unreal case
  return 0
}
handle_folder_none(){
  local source_path=$1
  local source_dir_name=$2
  local target_path=$3
  local target_dir_name=$4
  local error_code=0

  # Make directory in the target destination
  make_target_directory "$target_path" "$target_dir_name"
  error_code=$?
  if ! (($error_code == 0)); then
    return $error_code
  fi

  # Check if the source directory empty
  if [ "$(ls -A "$source_path/$source_dir_name")" ]; then
      # Copying data from source directory to target directory
      cp -rf "$source_path/$source_dir_name/"* "$target_path/$target_dir_name"
      error_code=$?
      if ! (($error_code == 0)); then
        return $error_code
      fi
  fi

    # Removing source directory
    rm -rf "${source_path:?}/${source_dir_name}"

    # Linking source directory to target directory
    make_link "$source_path" "$source_dir_name" "$target_path" "$target_dir_name"
    error_code=$?

  return $error_code
}
handle_link_folder(){
    # Unreal case
    return 0
}
handle_link_link(){
    # Unreal case
    return 0
}
handle_link_none(){
    local source_path=$1
    local source_dir_name=$2
    local target_path=$3
    local target_dir_name=$4
    local error_code=0

    if ! [ "$(readlink "$source_path"/"$source_dir_name")" == "$target_path"/"$target_dir_name" ]; then
        return 1
    fi

    make_target_directory "$target_path" "$target_dir_name"
    error_code=$?
    if ! (($error_code == 0)); then
      return $error_code
    fi

    return $error_code
}
handle_none_folder(){
    local source_path=$1
    local source_dir_name=$2
    local target_path=$3
    local target_dir_name=$4
    local error_code=0

    # Linking source directory to target directory
    make_link "$source_path" "$source_dir_name" "$target_path" "$target_dir_name"
    error_code=$?
    return $error_code
}
handle_none_link(){
  # Unreal case
  return 0
}
handle_none_none(){
      local source_path=$1
      local source_dir_name=$2
      local target_path=$3
      local target_dir_name=$4
      local error_code=0

      # Linking source directory to target directory
      make_link "$source_path" "$source_dir_name" "$target_path" "$target_dir_name"
      error_code=$?
      if ! (($error_code == 0)); then
        return $error_code
      fi

      make_target_directory "$target_path" "$target_dir_name"
      error_code=$?

      return $error_code
}

make_target_directory(){
      local target_path=$1
      local target_dir_name=$2
      local error_code=0
      # Make directory in the target destination
      mkdir "$target_path/$target_dir_name"
      error_code=$?

      return $error_code
}

make_link(){
      local source_path=$1
      local source_dir_name=$2
      local target_path=$3
      local target_dir_name=$4
      local error_code=0

      # Linking source directory to target directory
      ln -s "$target_path/$target_dir_name" "$source_path/$source_dir_name"
      error_code=$?
      if ! (($error_code == 0)); then
        return $error_code
      fi
}
get_linked_name(){
    local source_path=$1
    local source_relative_path=$(basename "$source_path")
    local target_dir_name="linked_$(echo "$source_relative_path" | sed -E 's|/|_|g' | sed -E 's|([a-z])([A-Z])|\1_\2|g' | sed -E 's/(^|_)([a-z])/\U\2/g' | sed -E 's/ /_/g')"
    echo "$target_dir_name"
}

move_and_link() {
    local source_path_dir=$1
    local target_path=$2

    local source_path=$(dirname "$source_path_dir")

    local current_case=$3

    local target_dir_name=$(get_linked_name $source_path_dir)
    local source_dir_name=$(basename "$source_path_dir")

    local target_path_dir="$target_path/$target_dir_name"

    local return_code=0

    if (( $current_case == $FOLDER_FOLDER )); then
      handle_folder_folder $source_path $source_dir_name $target_path $target_dir_name
      return_code=$?
    elif (( $current_case == $FOLDER_LINK )); then
      handle_folder_link $source_path $source_dir_name $target_path $target_dir_name
      return_code=$?
    elif (( $current_case == $FOLDER_NONE )); then
      handle_folder_none $source_path $source_dir_name $target_path $target_dir_name
      return_code=$?

    elif (( $current_case == $LINK_FOLDER )); then
      handle_link_folder $source_path $source_dir_name $target_path $target_dir_name
      return_code=$?
    elif (( $current_case == $LINK_LINK )); then
      handle_link_link $source_path $source_dir_name $target_path $target_dir_name
      return_code=$?
    elif (( $current_case == $LINK_NONE )); then
      handle_link_none $source_path $source_dir_name $target_path $target_dir_name
      return_code=$?

    elif (( $current_case == $NONE_FOLDER )); then
      handle_none_folder $source_path $source_dir_name $target_path $target_dir_name
      return_code=$?
    elif (( $current_case == $NONE_LINK )); then
      handle_none_link $source_path $source_dir_name $target_path $target_dir_name
      return_code=$?
    elif (( $current_case == $NONE_NONE )); then
      handle_none_none $source_path $source_dir_name $target_path $target_dir_name
      return_code=$?
    fi
    return $return_code

#    local FINISHED_FLAG=0
#
#    if ! [ "$(readlink \"$source_path_dir\")" == $target_path_dir ]; then
#        rm "$source_path_dir"
#    fi
#
#    if ! [ -d "$source_path_dir" ]; then
#        mkdir -p "$source_path_dir"
#    fi
#
#
#    if [[ -d "$target_path/$target_dir_name" && -d "$source_path_dir" ]]; then
#            mv -f "$source_path_dir" "$target_path"
#            mv -f "$target_path/$source_dir_name" "$target_path/$target_dir_name"
#        echo
#    fi
#
##    exit 1
#
#    if [ -L "$source_path_dir" ]; then
##        echo "${GREEN}$source_path_dir is already a symbolic link.${NC}"
#
#        if ! [ -d "$target_path_dir" ]; then
##            echo "I wanna create: $(readlink \"$target_path_dir\")"
##            mkdir -p "$(readlink \"$source_path_dir\")"
#            mkdir -p "$target_path_dir"
##            echo "${YELLOW}$(readlink $target_path_dir) was not created, It is created now ${NC}"
#        fi
#        FINISHED_FLAG=1
#    elif ! [ -d "$source_path_dir" ]; then
#        mkdir -p "$source_path_dir"
##        echo "${YELLOW}$source_path_dir is not a directory. Creating. I am gonna move it to $target_path${NC}"
#    fi
#    if [[ FINISHED_FLAG -eq 0 ]]; then
##        echo "Finished flag is not true, I am gonna make move and link"
#        if [[ -d "$target_path/$target_dir_name" && -d "$source_path_dir" ]]; then
#            # Removing source directory, because we already have such directory in goinfre
##            echo "${ORANGE}Removing $source_path_dir, because it is existed in goinfre already ${NC}"
##            mv "$source_path_dir" "$target_path/$target_dir_name"
##            rm -r "$source_path_dir"
#            echo
#        else
#            # Moving source directory to the target directory
##            echo "${ORANGE}Moving source directory to the target directory${NC}"
#            mv -f "$source_path_dir" "$target_path"
##            echo "${ORANGE}Renaming source directory after moving to the target directory${NC}"
#            # Renaming source directory after moving to the target directory
#            mv -f "$target_path/$source_dir_name" "$target_path/$target_dir_name"
#        fi
#
#        # Linking source directory to the target directory
#        ln -s "$target_path/$target_dir_name" "$source_path_dir"
#    fi
}

let COUNTER=1
let TOTAL_COUNT=${#paths[@]}

mkdir -p "$destination"

for path in "${paths[@]}"; do
    get_case "$path" "$destination"
    let CURRENT_CASE=$?
    move_and_link "$path" "$destination" $CURRENT_CASE
    let RETURN_CODE=$?
#    echo ""$path" "$destination" CURRENT_CASE: $CURRENT_CASE"
#    printf "Linked[${GREEN}%d${NC}/%d]: %s\n" $COUNTER $TOTAL_COUNT "$path"
    let COUNTER++
done