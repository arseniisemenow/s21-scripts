#!/bin/bash

rm -rf ~/Library/Containers/com.docker.docker
mkdir -p ~/goinfre/Docker/Data
ln -s ~/goinfre/Docker ~/Library/Containers/com.docker.docker

# Search for the directory matching the pattern
telegram_dir=$(find /Users/evangelm/Library/Group\ Containers/ -type d -name '*.ru.keepcoder.Telegram')
exit;
Check if a directory is found
if [ -n "$telegram_dir" ]; then
    echo "Telegram directory found: $telegram_dir"
    new_telegram_dir=~/goinfre/Telegram/$(basename "$telegram_dir")
        
    echo "$telegram_dir"
    echo "$new_telegram_dir"
    
    mkdir -p "$new_telegram_dir"
    
    cp -rf "$telegram_dir"/ "$new_telegram_dir"/
    rm -rf "$telegram_dir"
    ln -s "$new_telegram_dir" "$telegram_dir"
else
    echo "Telegram directory not found."
fi
