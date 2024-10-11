#!/usr/bin/bash

# Array of directories to potentially delete
directories=(
    "~/.config/share/nvim"
    "~/.local/share/nvim"
)

# Function to ask for confirmation
confirm_delete() {
    local dir=$1
    echo "Are you sure you want to delete $dir? (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]
    then
        echo "Deleting $dir"
        rm -rf "$dir"
    else
        echo "Skipping $dir"
    fi
}

# Main loop
for dir in "${directories[@]}"
do
    if [ -d "$dir" ]
    then
        confirm_delete "$dir"
    else
        echo "$dir does not exist or is not a directory. Skipping."
    fi
done

echo "Cleanup process completed."
