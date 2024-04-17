get_linked_name(){
    local source_path=$1
    local source_relative_path=$(basename "$source_path")
    local target_dir_name="linked_$(echo "$source_relative_path" | sed -E 's|/|_|g' | sed -E 's|([a-z])([A-Z])|\1_\2|g' | sed -E 's/(^|_)([a-z])/\U\2/g' | sed -E 's/ /_/g')"
    echo "$target_dir_name"
}
source_path="amongus"
echo "$source_path -> "$(get_linked_name "$source_path")
source_path="Amongus"
echo "$source_path -> "$(get_linked_name "$source_path")
source_path="_Amongus"
echo "$source_path -> "$(get_linked_name "$source_path")
source_path="Amongus."
echo "$source_path -> "$(get_linked_name "$source_path")
source_path="Amongus.com"
echo "$source_path -> "$(get_linked_name "$source_path")
source_path="Amongus.com.amon"
echo "$source_path -> "$(get_linked_name "$source_path")
