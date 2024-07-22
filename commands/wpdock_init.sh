#!/bin/bash

BASE_DIR="$(dirname "$(realpath "$0")")"

wpdock_help_init() {
    echo "wpdock init - Generate the WordPress project files and include the Docker configuration"
    echo
    echo "Usage: wpdock init"
    echo
    echo "This command copies template files to the current directory."
}

copy_files() {
    files=(
        '.env'
        'custom.ini'
        'Dockerfile'
        'docker-compose.yml'
    )

    source_dir="$(dirname "$0")/../template-files"
    dest_dir=".wpdock"

    # Create the .wpdock directory if it doesn't exist
    mkdir -p "$dest_dir"

    for file in "${files[@]}"; do
        source_file="$source_dir/$file"
        dest_file="$dest_dir/$file"
        if [[ ! -f "$dest_file" ]]; then
            cp "$source_file" "$dest_file"
            echo "Copied $file to $dest_dir"
        else
            echo "Skipped $file as it already exists in $dest_dir"
        fi
    done
}

wpdock_init() {
    copy_files
    "$BASE_DIR/wpdock_start.sh"
    echo "WordPress project initialized. Run 'wpdock install' to install WordPress."
}

if [[ "$1" == "--help" ]]; then
    wpdock_help_init
else
    wpdock_init
fi
