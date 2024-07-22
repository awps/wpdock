#!/bin/bash

wpdock_help_bash() {
    echo "wpdock bash - Open a bash shell in the WordPress container"
    echo
    echo "Usage: wpdock bash"
    echo
    echo "This command opens a bash shell in the WordPress container."
}

wpdock_bash() {
    docker-compose -f .wpdock/docker-compose.yml exec wordpress bash
}

if [[ "$1" == "--help" ]]; then
    wpdock_help_bash
else
    wpdock_bash
fi
