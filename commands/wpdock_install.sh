#!/bin/bash

wpdock_help_install() {
    echo "wpdock install - Install WordPress if not already installed"
    echo
    echo "Usage: wpdock install"
    echo
    echo "This command installs WordPress if it is not already installed."
    echo "You will be prompted for site title, admin username, admin password, and admin email."
}

wpdock_install() {
    docker-compose -f .wpdock/docker-compose.yml exec wordpress bash -c "
    wp core install --url='http://localhost:${WORDPRESS_PORT}' \
        --title='${WORDPRESS_TITLE}' \
        --admin_user='${WORDPRESS_ADMIN_USER}' \
        --admin_password='${WORDPRESS_ADMIN_PASSWORD}' \
        --admin_email='${WORDPRESS_ADMIN_EMAIL}' \
        --skip-email \
        --allow-root"
}

if [[ "$1" == "--help" ]]; then
    wpdock_help_install
else
    wpdock_install
fi
