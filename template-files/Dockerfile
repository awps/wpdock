ARG WORDPRESS_IMAGE

FROM ${WORDPRESS_IMAGE}

WORKDIR /var/www/html

# Install wp-cli
ENV WP_CLI_ALLOW_ROOT=1

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN php wp-cli.phar --info
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

# less is required for wp-cli
RUN apt-get update && apt-get install less