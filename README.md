# wpdock

> [!WARNING]
> # 🚧 Beta Warning 🚧
> 
> **Warning: This repository is currently in beta.**
> 
> Please be aware that this project is still under active development. As a result, the methods, APIs, and overall functionality may change frequently and without notice. I recommend using this project for testing and development purposes only and not in production environments.
> 
> I appreciate your interest and contributions! If you encounter any issues or have suggestions, please feel free to open an issue or submit a pull request.
> 
> Thank you for your understanding and support!


`wpdock` is a command-line tool to manage your WordPress Docker environment. It provides commands to initialize, start, stop, and manage your WordPress Docker containers, as well as install WordPress, handle cron jobs, and manage the site with WP CLI.

## Installation

To install `wpdock`, you need to have [Node.js](https://nodejs.org/) and [npm](https://www.npmjs.com/) installed. You can install `wpdock` globally using the following command:

```sh
npm install -g wpdock
```

## Usage

After installing `wpdock`, you can use it to manage your WordPress Docker environment. Below are the available commands:

### Commands

#### `wpdock init`

Generate the WordPress project files and include the Docker configuration. This sets up a basic structure for your WordPress project, including the necessary Docker configuration files.

**Usage:**

```sh
wpdock init
```

**What to expect:**

- The current directory will be populated with the following files:
  - `.env`
  - `custom.ini`
  - `Dockerfile`
  - `docker-compose.yml`
- These files are pre-configured to work with Docker, allowing you to quickly spin up a WordPress environment.

**Example:**

```sh
$ mkdir my-wordpress-site
$ cd my-wordpress-site
$ wpdock init
# Copied .env to current directory
# Copied custom.ini to current directory
# Copied Dockerfile to current directory
# Copied docker-compose.yml to current directory
```

#### `wpdock start`

Start the Docker containers for the WordPress environment. This command brings up the Docker containers as defined in your `docker-compose.yml` file.

**Usage:**

```sh
wpdock start
```

**What to expect:**

- The Docker containers for your WordPress environment will start, and you will see logs indicating their status.

**Example:**

```sh
$ wpdock start
# docker-compose: Creating network "my-wordpress-site_default" with the default driver
# docker-compose: Creating volume "my-wordpress-site_db_data" with default driver
# docker-compose: Creating my-wordpress-site-mysql-1 ... done
# docker-compose: Creating my-wordpress-site-wordpress-1 ... done
```

#### `wpdock stop`

Stop the Docker containers for the WordPress environment. This command stops all running containers defined in your `docker-compose.yml` file.

**Usage:**

```sh
wpdock stop
```

**What to expect:**

- The Docker containers for your WordPress environment will stop.

**Example:**

```sh
$ wpdock stop
# Stopping my-wordpress-site-wordpress-1 ... done
# Stopping my-wordpress-site-mysql-1 ... done
```

#### `wpdock delete`

Stop and remove all Docker containers and custom networks. This command is useful for cleaning up your Docker environment.

**Usage:**

```sh
wpdock delete
```

**What to expect:**

- All Docker containers and custom networks associated with your WordPress environment will be stopped and removed.

**Example:**

```sh
$ wpdock delete
# Stopping my-wordpress-site-wordpress-1 ... done
# Removing my-wordpress-site-wordpress-1 ... done
# Stopping my-wordpress-site-mysql-1 ... done
# Removing my-wordpress-site-mysql-1 ... done
# Removing network my-wordpress-site_default
```

#### `wpdock bash`

Open a bash shell in the WordPress container. This allows you to interact with the WordPress container directly. **Direct access to the WP CLI commands**.

**Usage:**

```sh
wpdock bash
```

**What to expect:**

- A bash shell will open inside the WordPress container, allowing you to run commands directly.

**Example:**

```sh
$ wpdock bash
# root@wordpress-container:/var/www/html#
```

#### `wpdock install`

Install WordPress if not already installed. You will be prompted for site title, admin username, admin password, and admin email.

**Usage:**

```sh
wpdock install
```

**What to expect:**

- The command will check if WordPress is installed. If not, it will prompt you for the necessary information and proceed with the installation.

**Example:**

```sh
$ wpdock install
# Site Title: My WordPress Site
# Admin Username: admin
# Admin Password: ********
# Admin Email: admin@example.com
# WordPress installed successfully.
```

#### `wpdock multisite-install`

Install WordPress multisite if not already installed. You will be prompted for site title, admin username, admin password, and admin email.

**Usage:**

```sh
wpdock multisite-install
```

#### `wpdock cron`

Manage WordPress cron jobs. This command allows you to start, stop, and manage cron jobs for your WordPress site.

**Usage:**

```sh
wpdock cron [-i interval] [-b] [-k] [-s] [-h]
```

- `-i interval`: The interval between pings in seconds (default: 10)
- `-b`: Run in background
- `-k`: Kill all cron processes running in the background
- `-s`: Use HTTPS instead of HTTP
- `-h`: Display this help message

**Examples:**

Run cron in the background:

```sh
$ wpdock cron -i 60 -b
# Cron is running in the background. PID: 12345
```

Kill all running cron processes:

```sh
$ wpdock cron -k
# All cron processes have been killed.
```

Display help message for cron:

```sh
$ wpdock cron -h
# Usage: wpdock cron [-i interval] [-b] [-k] [-s] [-h]
#   -i interval  The interval between pings in seconds (default: 10)
#   -b           Run in background
#   -k           Kill all cron processes running in the background
#   -s           Use HTTPS instead of HTTP
#   -h           Display this help message
```

## License

This project is licensed under the ISC License.
