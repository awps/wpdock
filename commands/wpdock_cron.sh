#!/bin/bash

wpdock_help_cron() {
    echo "wpdock cron - Manage WordPress cron jobs"
    echo
    echo "Usage: wpdock cron [-i interval] [-b] [-k] [-s] [-h]"
    echo "  -i interval  The interval between pings in seconds (default: 10)"
    echo "  -b           Run in background"
    echo "  -k           Kill all cron processes running in the background"
    echo "  -s           Use HTTPS instead of HTTP"
    echo "  -h           Display this help message"
}

wpdock_cron() {
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
            h) wpdock_help_cron; return 0 ;;
            *) wpdock_help_cron; return 1 ;;
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

if [[ "$1" == "--help" ]]; then
    wpdock_help_cron
else
    wpdock_cron "$@"
fi
