#!/bin/bash

wpdock_help_stop() {
    echo "wpdock stop - Stop the Docker containers"
    echo
    echo "Usage: wpdock stop"
    echo
    echo "This command stops the Docker containers for the WordPress environment."
}

wpdock_stop() {
    running_containers=$(docker ps -q)
    if [[ -z "$running_containers" ]]; then
        echo "No running containers to stop."
    else
        docker stop "$running_containers"
    fi
}

if [[ "$1" == "--help" ]]; then
    wpdock_help_stop
else
    wpdock_stop
fi
