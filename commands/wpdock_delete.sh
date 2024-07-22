#!/bin/bash

wpdock_help_delete() {
    echo "wpdock delete - Stop and remove Docker containers and custom networks"
    echo
    echo "Usage: wpdock delete [--all]"
    echo
    echo "This command stops and removes Docker containers and custom networks for the current project."
    echo "If the --all option is provided, it will stop and remove all Docker containers and custom networks."
}

# Get the directory name of the current script to use as the Docker Compose project name
PROJECT_NAME=$(basename "$PWD")

wpdock_delete() {
    if [[ "$1" == "--all" ]]; then
        # Remove all containers and networks
        echo "Deleting all containers and networks..."

        # Stop and remove all containers
        ALL_CONTAINERS=$(docker ps -aq)
        if [[ -z "$ALL_CONTAINERS" ]]; then
            echo "No containers to delete."
        else
            docker stop "$ALL_CONTAINERS"
            docker rm "$ALL_CONTAINERS"
        fi

        # Remove all custom Docker networks
        ALL_NETWORKS=$(docker network ls -q --filter type=custom)
        if [[ -z "$ALL_NETWORKS" ]]; then
            echo "No custom networks to delete."
        else
            docker network rm "$ALL_NETWORKS"
        fi

        echo "All containers and networks deleted."
    else
        # Get a list of all containers for the current project
        CONTAINERS=$(docker ps -aq --filter "label=com.docker.compose.project=${PROJECT_NAME}")

        # Check if there are no containers for the project
        if [[ -z "$CONTAINERS" ]]; then
            echo "No containers to delete for project $PROJECT_NAME."
            return
        fi

        # Stop and remove each container for the project
        for i in ${CONTAINERS}; do
            docker stop "${i}"
            docker rm "${i}"
        done

        # Remove all custom Docker networks for the project
        NETWORKS=$(docker network ls -q --filter "label=com.docker.compose.project=${PROJECT_NAME}")
        if [[ -n "$NETWORKS" ]]; then
            docker network rm "${NETWORKS}"
        fi

        echo "Project containers and networks deleted."
    fi
}

# If this script is run directly, call the function
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    wpdock_delete "$@"
fi
