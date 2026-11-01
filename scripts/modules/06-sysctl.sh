#!/usr/bin/env bash
# ==============================================================================
# Module: Kernel & Network Stack Hardening (Sysctl)
# Description: Fortifies kernel parameters against SYN floods, IP spoofing, and redirects.
# ==============================================================================

set -euo pipefail

SYSCTL_CONF="/etc/sysctl.d/99-security-hardening.conf"

log_info() { echo -e "\033[1;33m[INFO]\033[0m $1"; }
log_success() { echo -e "\033[0;32m[SUCCESS]\033[0m $1"; }
log_error() { echo -e "\033[0;31m[ERROR]\033[0m $1"; exit 1; }

harden_kernel() {
    log_info "Applying kernel network stack and security hardening parameters..."

    cat << EOF > "$SYSCTL_CONF"
# --- Network Security & Spoofing Protections ---
# Enable IP spoofing protection (Reverse Path Filtering)
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# Disable IP forwarding (prevent acting as an unauthorized router)
net.ipv4.ip_forward = 0
net.ipv6.conf.all.forwarding = 0

# Protect against SYN flood attacks using SYN cookies
net.ipv4.tcp_syncookies = 1

# Ignore ICMP redirects to prevent routing table tampering
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0

# Ignore send redirects
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0

# Log martian packets (packets with impossible source addresses)
net.ipv4.conf.all.log_martians = 1

# --- Kernel Core Dump & Memory Protection ---
# Restrict core dumps to prevent leaking sensitive application memory
fs.suid_dumpable = 0
EOF

    # Apply sysctl parameters immediately
    log_info "Reloading sysctl parameters..."
    sysctl --system > /dev/null

    log_success "Kernel security and network stack hardening applied successfully."
}

# Execute if run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    harden_kernel
fi
