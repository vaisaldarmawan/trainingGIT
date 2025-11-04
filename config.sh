#!/bin/bash

# Application Environment
export APP_ENV="development"

# Database Configuration
export DB_HOST="localhost"
export DB_USER="root"
export DB_PASS="password"

# Echo confirmation
echo "Environment variables have been set:"
echo "APP_ENV: $APP_ENV"
echo "DB_HOST: $DB_HOST"
echo "DB_USER: $DB_USER"
echo "DB_PASS: $DB_PASS"
