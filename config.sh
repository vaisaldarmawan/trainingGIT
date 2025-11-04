#!/bin/bash

#==============================================================================
# Title: Configuration Environment Setup Script
# Description: Sets up environment variables for application configuration
# Author: vaisaldarmawan
# Date: November 4, 2025
# Version: 1.0
#==============================================================================

# Enable strict mode
set -euo pipefail
IFS=$'\n\t'

# Constants
readonly LOG_FILE="/tmp/config-$(date +%Y%m%d).log"
readonly VALID_ENVIRONMENTS=("development" "staging" "production")

# Logging function
log() {
    local message="[$(date +'%Y-%m-%d %H:%M:%S')] $1"
    echo "$message" | tee -a "$LOG_FILE"
}

# Validate environment
validate_environment() {
    local env="$1"
    for valid_env in "${VALID_ENVIRONMENTS[@]}"; do
        if [[ "$env" == "$valid_env" ]]; then
            return 0
        fi
    done
    log "ERROR: Invalid environment '$env'. Must be one of: ${VALID_ENVIRONMENTS[*]}"
    return 1
}

# Main configuration function
setup_configuration() {
    log "Starting configuration setup..."

    # Application Environment
    APP_ENV=${APP_ENV:-"development"}
    if ! validate_environment "$APP_ENV"; then
        exit 1
    fi
    export APP_ENV

    # Database Configuration with defaults
    export DB_HOST=${DB_HOST:-"localhost"}
    export DB_USER=${DB_USER:-"root"}
    
    # Securely handle password
    if [[ -z "${DB_PASS:-}" ]]; then
        log "WARNING: Database password not set. Using default (not recommended for production)"
        export DB_PASS="password"
    fi

    # Validate database connection
    if [[ "$APP_ENV" == "production" ]]; then
        log "Validating database configuration..."
        if ! ping -c 1 "$DB_HOST" &>/dev/null; then
            log "ERROR: Cannot reach database host: $DB_HOST"
            exit 1
        fi
    fi

    # Output configuration (masking sensitive data)
    log "Environment variables have been set:"
    log "APP_ENV: $APP_ENV"
    log "DB_HOST: $DB_HOST"
    log "DB_USER: $DB_USER"
    log "DB_PASS: ********"
}

# Execute main function
setup_configuration
