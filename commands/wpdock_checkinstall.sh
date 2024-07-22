#!/bin/bash

wpdock_checkinstall() {
    # Path to docker-compose.yml
    local compose_path=".wpdock/docker-compose.yml"

    docker-compose -f "$compose_path" exec wordpress bash -c "
    if wp core is-installed --allow-root; then
        echo 'WordPress is already installed.';
    else
        echo 'WordPress is not installed.';
    fi"
}

wpdock_checkinstall
