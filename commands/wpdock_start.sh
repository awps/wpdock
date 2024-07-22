#!/bin/bash

wpdock_help_start() {
    echo "wpdock start - Start the Docker containers"
    echo
    echo "Usage: wpdock start [--rebuild]"
    echo
    echo "This command starts the Docker containers for the WordPress environment."
    echo "If the --rebuild option is provided, it will rebuild the Docker containers before starting them."
}

wpdock_start() {
    # Parse the --rebuild option
    local rebuild_option=""
    if [[ "$1" == "--rebuild" ]]; then
        rebuild_option="--build"
    fi

    # Stop all running containers to avoid conflicts
    docker stop $(docker ps -q) 2>/dev/null

    # Path to docker-compose.yml
    local compose_path=".wpdock/docker-compose.yml"

    # Start or rebuild and start the containers of this project
    docker-compose -f "$compose_path" up $rebuild_option -d 2>&1 | while IFS= read -r line; do
        echo "docker-compose: $line"
    done
}

if [[ "$1" == "--help" ]]; then
    wpdock_help_start
else
    wpdock_start "$@"
fi
