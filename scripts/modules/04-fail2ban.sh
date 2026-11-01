#!/usr/bin/env bash
# ==============================================================================
# Module: Fail2ban Brute-Force Protection
# Description: Installs and configures Fail2ban to block malicious login attempts.
# ==============================================================================

set -euo pipefail

log_info() { echo -e "\033[1;33m[INFO]\033[0m $1"; }
log_success() { echo -e "\033[0;32m[SUCCESS]\033[0m $1"; }
log_error() { echo -e "\033[0;31m[ERROR]\033[0m $1"; exit 1; }

configure_fail2ban() {
    log_info "Configuring Fail2ban intrusion prevention..."

    # Install fail2ban if not present
    if ! command -v fail2ban-client &> /dev/null; then
        log_info "Fail2ban not found. Installing package..."
        apt-get update -y && apt-get install -y fail2ban
    fi

    # Create jail.local configuration for SSH protection
    local jail_local="/etc/fail2ban/jail.local"
    log_info "Writing custom jail configuration to $jail_local..."

    cat << EOF > "$jail_local"
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 3

[sshd]
enabled = true
port = ssh
logpath = %(sshd_log)s
backend = %(sshd_backend)s
EOF

    # Enable and start fail2ban service
    log_info "Enabling and starting fail2ban service..."
    systemctl enable fail2ban
    systemctl restart fail2ban

    log_success "Fail2ban successfully configured and active protecting SSH."
    fail2ban-client status
}

# Execute if run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    configure_fail2ban
fi
