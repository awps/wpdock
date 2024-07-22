#!/bin/bash

echo "wpdock - A tool to manage your WordPress Docker environment"
echo
echo "Usage: wpdock <command> [options]"
echo
echo "Commands:"
echo "  init                Generate the WordPress project files and include the Docker configuration"
echo "  install             Install WordPress if not already installed"
echo "  start               Start the Docker containers"
echo "  stop                Stop the Docker containers"
echo "  bash                Open a bash shell in the WordPress container"
echo "  cron                Manage WordPress cron jobs"
echo "  delete              Stop and remove current or all Docker containers and custom networks"
echo
echo "Options:"
echo "  --help              Show this help message"
echo
echo "Use 'wpdock <command> --help' for more information about a command."
