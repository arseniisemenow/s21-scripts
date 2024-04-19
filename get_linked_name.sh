get_linked_name(){
    local path=$1
    local new_path="${path//\//_}"
    new_path="${new_path// /_}"
    new_path="${new_path//./_}"
    new_path="${new_path//-/_}"
    new_path="linked${new_path}"
    echo "$new_path"
}
path="$HOME/Applications"
echo "$path -> "$(get_linked_name "$path")
path="$HOME/Library/Caches/Google"
echo "$path -> "$(get_linked_name "$path")
path="$HOME/Library/Caches/JetBrains"
echo "$path -> "$(get_linked_name "$path")
path="$HOME/Library/Application Support/Google"
echo "$path -> "$(get_linked_name "$path")
path="$HOME/Library/Application Support/JetBrains"
echo "$path -> "$(get_linked_name "$path")
path="$HOME/Library/Containers/com.docker.docker"
echo "$path -> "$(get_linked_name "$path")
path="$HOME/Library/Containers/com.apple.Safari"
echo "$path -> "$(get_linked_name "$path")
path="$HOME/Library/Java"
echo "$path -> "$(get_linked_name "$path")
path="$HOME/Pictures"
echo "$path -> "$(get_linked_name "$path")
path="$HOME/Pictures-amongus"
echo "$path -> "$(get_linked_name "$path")