#!/usr/bin/env bash
# ==============================================================================
# Module: SSH Daemon Hardening
# Description: Secures SSH configuration against root login and brute-force vectors.
# ==============================================================================

set -euo pipefail

SSHD_CONFIG="/etc/ssh/sshd_config"
BACKUP_DIR="/etc/ssh/backup"

log_info() { echo -e "\033[1;33m[INFO]\033[0m $1"; }
log_success() { echo -e "\033[0;32m[SUCCESS]\033[0m $1"; }
log_error() { echo -e "\033[0;31m[ERROR]\033[0m $1"; exit 1; }

harden_ssh() {
    log_info "Starting SSH daemon fortification..."

    # Create backup directory if it doesn't exist
    mkdir -p "$BACKUP_DIR"
    local backup_file="$BACKUP_DIR/sshd_config.bak_$(date +%F_%T)"
    cp "$SSHD_CONFIG" "$backup_file"
    log_info "Backed up existing SSH configuration to $backup_file"

    # Define desired SSH configurations
    declare -A ssh_settings=(
        ["PermitRootLogin"]="no"
        ["PasswordAuthentication"]="no"
        ["X11Forwarding"]="no"
        ["MaxAuthTries"]="3"
        ["PermitEmptyPasswords"]="no"
        ["ClientAliveInterval"]="300"
        ["ClientAliveCountMax"]="2"
    )

    # Apply or update settings idempotently
    for key in "${!ssh_settings[@]}"; do
        local value="${ssh_settings[$key]}"
        if grep -qE "^#?\s*${key}\s+" "$SSHD_CONFIG"; then
            sed -i -E "s/^#?\s*${key}\s+.*/${key} ${value}/" "$SSHD_CONFIG"
        else
            echo "${key} ${value}" >> "$SSHD_CONFIG"
        fi
        log_info "Configured: ${key} = ${value}"
    done

    # CRITICAL: Validate sshd configuration syntax before restarting service
    log_info "Validating SSH configuration syntax..."
    if sshd -t; then
        log_success "SSH configuration syntax check passed."
    else
        log_error "SSH configuration syntax check FAILED! Restoring from backup..."
        cp "$backup_file" "$SSHD_CONFIG"
        exit 1
    fi

    # Restart SSH service safely
    systemctl restart ssh || systemctl restart sshd
    log_success "SSH daemon successfully restarted with hardened profile."
}

# Execute if run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    harden_ssh
fi
