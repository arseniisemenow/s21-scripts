#!/bin/bash

paths=(
    "$HOME/Applications"
    "$HOME/Library/Caches/Google"
    "$HOME/Library/Caches/JetBrains"
    "$HOME/Library/Application Support/Google"
    "$HOME/Library/Application Support/JetBrains"
    "$HOME/Library/Application Support/zoom.us"
    "$HOME/Library/Containers/com.docker.docker"
    "$HOME/Library/Containers/com.apple.Safari"
    "$HOME/Library/Java"
    "$HOME/Pictures"
    "$HOME/Music"
)

destination="$HOME/goinfre/linked"

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

FOLDER_FOLDER_OUTPUT_STRING="Folder-Folder"
FOLDER_LINK_OUTPUT_STRING="Folder-Link"
FOLDER_NONE_OUTPUT_STRING="Folder-None"
LINK_FOLDER_OUTPUT_STRING="Link-Folder"
LINK_LINK_OUTPUT_STRING="Link-Link"
LINK_NONE_OUTPUT_STRING="Link-None"
NONE_FOLDER_OUTPUT_STRING="None-Folder"
NONE_LINK_OUTPUT_STRING="None-Link"
NONE_NONE_OUTPUT_STRING="None-None"

OUTPUT_STRING_ARRAY=(
  "$FOLDER_FOLDER_OUTPUT_STRING"
  "$FOLDER_LINK_OUTPUT_STRING"
  "$FOLDER_NONE_OUTPUT_STRING"
  "$LINK_FOLDER_OUTPUT_STRING"
  "$LINK_LINK_OUTPUT_STRING"
  "$LINK_NONE_OUTPUT_STRING"
  "$NONE_FOLDER_OUTPUT_STRING"
  "$NONE_LINK_OUTPUT_STRING"
  "$NONE_NONE_OUTPUT_STRING"
)

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
      return $LINK_FOLDER
    elif [[ -L "$source_path_dir" && -L $target_path_dir ]]; then
      return $LINK_LINK
    elif [[ -L "$source_path_dir" && ! -e $target_path_dir ]]; then
      return $LINK_NONE
    elif [[ -d "$source_path_dir" && -d $target_path_dir ]]; then
      return $FOLDER_FOLDER
    elif [[ -d "$source_path_dir" && -L $target_path_dir ]]; then
      return $FOLDER_LINK
    elif [[ -d "$source_path_dir" && ! -e $target_path_dir ]]; then
      return $FOLDER_NONE
    elif [[ ! -e "$source_path_dir" && -d $target_path_dir ]]; then
      return $NONE_FOLDER
    elif [[ ! -e "$source_path_dir" && -L $target_path_dir ]]; then
      return $NONE_LINK
    elif [[ ! -e "$source_path_dir" && ! -e $target_path_dir ]]; then
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

  handle_folder_none "$source_path" "$source_dir_name" "$target_path" "$target_dir_name"
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
    local source_path=$1
    local source_dir_name=$2
    local target_path=$3
    local target_dir_name=$4
    local error_code=0

    if ! [ "$(readlink "$source_path"/"$source_dir_name")" == "$target_path"/"$target_dir_name" ]; then
        rm "$source_path"/"$source_dir_name"
        make_link "$source_path" "$source_dir_name" "$target_path" "$target_dir_name"
    fi
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
        rm "$source_path"/"$source_dir_name"
        make_link "$source_path" "$source_dir_name" "$target_path" "$target_dir_name"
    fi
    # Create target directory
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
     local path=$1
     local new_path="${path//\//_}"
     new_path="${new_path// /_}"
     new_path="${new_path//./_}"
     new_path="${new_path//-/_}"
     new_path="linked${new_path}"
     echo "$new_path"
 }
move_and_link() {
    local source_path_dir=$1
    local target_path=$2

    local source_path
    source_path=$(dirname "$source_path_dir")

    local current_case=$3

    local target_dir_name
    target_dir_name=$(get_linked_name "$source_path_dir")
    local source_dir_name
    source_dir_name=$(basename "$source_path_dir")

    local target_path_dir="$target_path/$target_dir_name"

    local return_code=0

    if (( current_case == FOLDER_FOLDER )); then
      handle_folder_folder "$source_path" "$source_dir_name" "$target_path" "$target_dir_name"
      return_code=$?
    elif (( current_case == FOLDER_LINK )); then
      handle_folder_link "$source_path" "$source_dir_name" "$target_path" "$target_dir_name"
      return_code=$?
    elif (( current_case == FOLDER_NONE )); then
      handle_folder_none "$source_path" "$source_dir_name" "$target_path" "$target_dir_name"
      return_code=$?

    elif (( current_case == LINK_FOLDER )); then
      handle_link_folder "$source_path" "$source_dir_name" "$target_path" "$target_dir_name"
      return_code=$?
    elif (( current_case == LINK_LINK )); then
      handle_link_link "$source_path" "$source_dir_name" "$target_path" "$target_dir_name"
      return_code=$?
    elif (( current_case == LINK_NONE )); then
      handle_link_none "$source_path" "$source_dir_name" "$target_path" "$target_dir_name"
      return_code=$?

    elif (( current_case == NONE_FOLDER )); then
      handle_none_folder "$source_path" "$source_dir_name" "$target_path" "$target_dir_name"
      return_code=$?
    elif (( current_case == NONE_LINK )); then
      handle_none_link "$source_path" "$source_dir_name" "$target_path" "$target_dir_name"
      return_code=$?
    elif (( current_case == NONE_NONE )); then
      handle_none_none "$source_path" "$source_dir_name" "$target_path" "$target_dir_name"
      return_code=$?
    fi
    return $return_code
}

let COUNTER=1
let TOTAL_COUNT=${#paths[@]}

mkdir -p "$destination"

for path in "${paths[@]}"; do
    get_case "$path" "$destination"
    let current_case=$?

    move_and_link "$path" "$destination" $current_case
    let return_code=$?

    let normalized_index=$current_case-100

    if (( return_code == 0 )); then
        echo "[${COUNTER}/${TOTAL_COUNT}][${OUTPUT_STRING_ARRAY[$normalized_index]}]. Path:${path} ${GREEN}[SUCCESS]${NC} "
    else
        echo "[${COUNTER}/${TOTAL_COUNT}][${OUTPUT_STRING_ARRAY[$normalized_index]}]. Path:${path} ${RED}[FAIL]${NC} "
    fi
    let COUNTER++
done