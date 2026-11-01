#!/usr/bin/env bash
# ==============================================================================
# Module: Automated Security Updates
# Description: Configures unattended-upgrades for automatic security patching.
# ==============================================================================

set -euo pipefail

log_info() { echo -e "\033[1;33m[INFO]\033[0m $1"; }
log_success() { echo -e "\033[0;32m[SUCCESS]\033[0m $1"; }
log_error() { echo -e "\033[0;31m[ERROR]\033[0m $1"; exit 1; }

configure_updates() {
    log_info "Configuring automated security updates..."

    # Install unattended-upgrades if missing
    if ! dpkg -l | grep -q unattended-upgrades; then
        log_info "Installing unattended-upgrades package..."
        apt-get update -y && apt-get install -y unattended-upgrades apt-listchanges
    fi

    # Configure auto-updates interval
    local auto_upgrades_file="/etc/apt/apt.conf.d/20auto-upgrades"
    log_info "Writing automated upgrade configuration to $auto_upgrades_file..."

    cat << EOF > "$auto_upgrades_file"
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::AutocleanInterval "7";
EOF

    log_success "Unattended security upgrades successfully configured."
}

# Execute if run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    configure_updates
fi
