#!/usr/bin/env node

import { exec, spawn } from 'child_process';
import fs from 'fs';
import path from 'path';
import inquirer from 'inquirer';
import dotenv from 'dotenv';

const scriptPath = path.join(path.dirname(new URL(import.meta.url).pathname), 'wpdock.sh');

// get the .env file from current project directory under the subfolder .wpdock is the .env file
const envPath = path.join(process.cwd(), '.wpdock', '.env');

dotenv.config({
    path: envPath
});

function ensureExecutable(filePath) {
    try {
        const stats = fs.statSync(filePath);
        const isExecutable = (stats.mode & 0o111) !== 0; // Check if any execute bit is set
        if (!isExecutable) {
            fs.chmodSync(filePath, '755');
            console.log(`${filePath} is now executable.`);
        }
    } catch (err) {
        console.error(`Failed to check or set executable permission for ${filePath}: ${err.message}`);
        process.exit(1);
    }
}

function executeCommand(command, args = [], options = {}) {
    const fullCommand = `${scriptPath} ${command} ${args.join(' ')}`;
    const runCommand = () => {
        const child = spawn(fullCommand, {
            shell: true,
            stdio: 'inherit',
            cwd: process.cwd(),
            env: { ...process.env, ...options.env }
        });

        child.on('close', (code) => {
            if (code !== 0) {
                console.error(`${command} command exited with code ${code}`);
            }
        });
    };

    if (command === 'init' && !options.skipConfirmation) {
        const i = inquirer.prompt([
            {
                type: 'confirm',
                name: 'confirm',
                message: 'This will copy files to the current directory. Do you want to proceed?',
                default: false
            }
        ]).then(answers => {
            if (answers.confirm) {
                runCommand();
            } else {
                console.log('Operation cancelled.');
            }
        });
    } else if (command === 'install') {
        exec(`${scriptPath} checkinstall`, { cwd: process.cwd() }, (error, stdout, stderr) => {
            if (error) {
                console.error(`Error checking WordPress installation: ${error.message}`);
                return;
            }
            if (stdout.includes('WordPress is not installed.')) {
                inquirer.prompt([
                    {
                        type: 'input',
                        name: 'title',
                        message: 'Site Title:'
                    },
                    {
                        type: 'input',
                        name: 'admin_user',
                        message: 'Admin Username:'
                    },
                    {
                        type: 'password',
                        name: 'admin_password',
                        message: 'Admin Password:'
                    },
                    {
                        type: 'input',
                        name: 'admin_email',
                        message: 'Admin Email:'
                    }
                ]).then(answers => {
                    const { title, admin_user, admin_password, admin_email } = answers;
                    const env = {
                        ...process.env,
                        WORDPRESS_TITLE: title,
                        WORDPRESS_ADMIN_USER: admin_user,
                        WORDPRESS_ADMIN_PASSWORD: admin_password,
                        WORDPRESS_ADMIN_EMAIL: admin_email
                    };

                    const install = spawn(scriptPath, [command], { stdio: 'inherit', cwd: process.cwd(), env });

                    install.on('close', (code) => {
                        if (code !== 0) {
                            console.error(`install command exited with code ${code}`);
                        }
                    });
                });
            } else {
                console.log('WordPress is already installed.');
            }
        });
    } else {
        runCommand();
    }
}

const args = process.argv.slice(2);
const command = args[0];
const commandArgs = args.slice(1);

// Ensure the script is executable once
ensureExecutable(scriptPath);

switch (command) {
    case 'init':
    case 'start':
    case 'stop':
    case 'delete':
    case 'bash':
    case 'install':
    case 'checkinstall':
    case 'cron':
        executeCommand(command, commandArgs);
        break;
    case '--help':
    default:
        executeCommand('--help');
        break;
}
