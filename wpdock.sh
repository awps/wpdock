#!/bin/bash

show_help() {
    echo "wpdock - A tool to manage your WordPress Docker environment"
    echo
    echo "Usage: wpdock <command> [options]"
    echo
    echo "Commands:"
    echo "  init                Generate the WordPress project files and include the Docker configuration"
    echo "  start               Start the Docker containers"
    echo "  stop                Stop the Docker containers"
    echo "  delete              Stop and remove all Docker containers and custom networks"
    echo "  bash                Open a bash shell in the WordPress container"
    echo "  install             Install WordPress if not already installed"
    echo "  cron                Manage WordPress cron jobs"
    echo
    echo "Options:"
    echo "  --help              Show this help message"
    echo
    echo "Use 'wpdock <command> --help' for more information about a command."
}

show_help_init() {
    echo "wpdock init - Generate the WordPress project files and include the Docker configuration"
    echo
    echo "Usage: wpdock init"
    echo
    echo "This command copies template files to the current directory."
}

show_help_start() {
    echo "wpdock start - Start the Docker containers"
    echo
    echo "Usage: wpdock start"
    echo
    echo "This command starts the Docker containers for the WordPress environment."
}

show_help_stop() {
    echo "wpdock stop - Stop the Docker containers"
    echo
    echo "Usage: wpdock stop"
    echo
    echo "This command stops the Docker containers for the WordPress environment."
}

show_help_delete() {
    echo "wpdock delete - Stop and remove all Docker containers and custom networks"
    echo
    echo "Usage: wpdock delete"
    echo
    echo "This command stops and removes all Docker containers and custom networks."
}

show_help_bash() {
    echo "wpdock bash - Open a bash shell in the WordPress container"
    echo
    echo "Usage: wpdock bash"
    echo
    echo "This command opens a bash shell in the WordPress container."
}

show_help_install() {
    echo "wpdock install - Install WordPress if not already installed"
    echo
    echo "Usage: wpdock install"
    echo
    echo "This command installs WordPress if it is not already installed."
    echo "You will be prompted for site title, admin username, admin password, and admin email."
}

show_help_cron() {
    echo "wpdock cron - Manage WordPress cron jobs"
    echo
    echo "Usage: wpdock cron [-i interval] [-b] [-k] [-s] [-h]"
    echo "  -i interval  The interval between pings in seconds (default: 10)"
    echo "  -b           Run in background"
    echo "  -k           Kill all cron processes running in the background"
    echo "  -s           Use HTTPS instead of HTTP"
    echo "  -h           Display this help message"
}

sitestop() {
    running_containers=$(docker ps -q)
    if [[ -z "$running_containers" ]]; then
        echo "No running containers to stop."
    else
        docker stop $running_containers
    fi
}

sitedelete() {
    CONTAINERS=$(docker ps -aq --format "{{.Names}}")

    if [[ -z "$CONTAINERS" ]]; then
        echo "No containers to delete."
        return
    fi

    for i in ${CONTAINERS}; do
        docker stop ${i}
        docker rm ${i}
    done

    docker network rm $(docker network ls -q --filter type=custom)

    echo "Done!"
}

sitego() {
    sitestop
    docker-compose up -d 2>&1 | while IFS= read -r line; do
        echo "docker-compose: $line"
    done
}

sitebash() {
    docker-compose exec wordpress bash
}

siteinstall() {
    docker-compose exec wordpress bash -c "
    wp core install --url='http://localhost:${WORDPRESS_PORT}' \
        --title='${WORDPRESS_TITLE}' \
        --admin_user='${WORDPRESS_ADMIN_USER}' \
        --admin_password='${WORDPRESS_ADMIN_PASSWORD}' \
        --admin_email='${WORDPRESS_ADMIN_EMAIL}' \
        --skip-email \
        --allow-root"
}

checkinstall() {
    docker-compose exec wordpress bash -c "
    if wp core is-installed --allow-root; then
        echo 'WordPress is already installed.';
    else
        echo 'WordPress is not installed.';
    fi"
}

cron() {
    interval=10
    background=false
    kill_processes=false
    use_https=false
    url="localhost"
    port="${WORDPRESS_PORT}"

    while getopts "i:bksh" opt; do
        case $opt in
            i) interval=$OPTARG ;;
            b) background=true ;;
            k) kill_processes=true ;;
            s) use_https=true ;;
            h) show_help_cron; return 0 ;;
            *) show_help_cron; return 1 ;;
        esac
    done

    log_message() {
        message=$1
        echo "$message"
    }

    kill_cron() {
        pkill -f "cron_task"
        log_message "All cron processes have been killed."
    }

    protocol="http"
    if $use_https; then
        protocol="https"
    fi

    full_url="$protocol://$url:$port/wp-cron.php"

    cron_task() {
        log_message "Cron started"
        count=0

        while true; do
            count=$((count+1))
            wget -qO- "$full_url" &> /dev/null
            log_message " ---- Cron executed $count times on URL: $full_url"
            sleep "$interval"
        done
    }

    if $kill_processes; then
        kill_cron
        exit 0
    fi

    if $background; then
        cron_task &
        log_message "Cron is running in the background. PID: $!"
    else
        cron_task
    fi
}

copyFiles() {
    files=(
        '.env'
        'custom.ini'
        'Dockerfile'
        'docker-compose.yml'
    )

    sourceDir="$(dirname "$0")/template-files"

    for file in "${files[@]}"; do
        sourceFile="$sourceDir/$file"
        destFile="./$file"
        if [[ ! -f "$destFile" ]]; then
            cp "$sourceFile" "$destFile"
            echo "Copied $file to current directory"
        else
            echo "Skipped $file as it already exists in the current directory"
        fi
    done
}

case "$1" in
    "start")
        if [[ "$2" == "--help" ]]; then
            show_help_start
        else
            sitego
        fi
        ;;
    "stop")
        if [[ "$2" == "--help" ]]; then
            show_help_stop
        else
            sitestop
        fi
        ;;
    "delete")
        if [[ "$2" == "--help" ]]; then
            show_help_delete
        else
            sitedelete
        fi
        ;;
    "init")
        if [[ "$2" == "--help" ]]; then
            show_help_init
        else
            copyFiles
            sitego
            echo "WordPress project initialized. Run 'wpdock install' to install WordPress."
        fi
        ;;
    "bash")
        if [[ "$2" == "--help" ]]; then
            show_help_bash
        else
            sitebash
        fi
        ;;
    "install")
        if [[ "$2" == "--help" ]]; then
            show_help_install
        else
            siteinstall
        fi
        ;;
    "checkinstall")
        checkinstall
        ;;
    "cron")
        if [[ "$2" == "--help" ]]; then
            show_help_cron
        else
            shift
            cron "$@"
        fi
        ;;
    *)
        if [[ "$1" == "--help" ]]; then
            show_help
        else
            echo "Invalid command. Use --help for usage information."
        fi
        ;;
esac
