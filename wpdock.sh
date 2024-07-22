#!/bin/bash
# Get the directory of the current script
BASE_DIR="$(dirname "$(realpath "$0")")"

# Ensure all necessary scripts have execute permissions
chmod +x "$BASE_DIR"/*.sh "$BASE_DIR"/commands/*.sh

show_help() {
    "$BASE_DIR/commands/wpdock_help.sh"
}

COMMAND="$1"
shift

if [[ -f "$BASE_DIR/commands/wpdock_${COMMAND}.sh" ]]; then
    if [[ "$1" == "--help" ]]; then
        "$BASE_DIR/commands/wpdock_${COMMAND}.sh" --help
    else
        "$BASE_DIR/commands/wpdock_${COMMAND}.sh" "$@"
    fi
else
    if [[ "$COMMAND" == "--help" ]]; then
        show_help
    else
        echo "Invalid command. Use --help for usage information."
    fi
fi
