#!/usr/bin/env bash
# ==============================================================================
# Module: Firewall Configuration (UFW)
# Description: Enforces default-deny incoming rules and allows critical ports.
# ==============================================================================

set -euo pipefail

log_info() { echo -e "\033[1;33m[INFO]\033[0m $1"; }
log_success() { echo -e "\033[0;32m[SUCCESS]\033[0m $1"; }
log_error() { echo -e "\033[0;31m[ERROR]\033[0m $1"; exit 1; }

configure_firewall() {
    log_info "Configuring Uncomplicated Firewall (UFW)..."

    # Check if ufw is installed, install if missing
    if ! command -v ufw &> /dev/null; then
        log_info "UFW not found. Installing ufw package..."
        apt-get update -y && apt-get install -y ufw
    fi

    # Set default policies
    log_info "Setting default firewall policies (Deny incoming, Allow outgoing)..."
    ufw --force default deny incoming
    ufw default allow outgoing

    # Allow essential services (SSH, HTTP, HTTPS)
    log_info "Opening essential ports (SSH, HTTP, HTTPS)..."
    ufw allow ssh
    ufw allow http
    ufw allow https

    # Enable firewall non-interactively
    log_info "Enforcing UFW active status..."
    ufw --force enable

    log_success "Firewall successfully configured and enabled."
    ufw status verbose
}

# Execute if run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    configure_firewall
fi
