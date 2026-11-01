#!/usr/bin/env bash
# ==============================================================================
# Module: Pre-flight System Validation
# Description: Validates root privileges and OS environment compatibility.
# ==============================================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() { echo -e "${YELLOW}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

run_prechecks() {
    log_info "Initiating pre-flight system checks..."

    # 1. Check root UID
    if [[ $EUID -ne 0 ]]; then
        log_error "This hardening script must be executed with root (sudo) privileges."
    fi
    log_success "Root privileges verified."

    # 2. Check OS Release Compatibility
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        if [[ "$ID" != "ubuntu" && "$ID" != "debian" ]]; then
            log_error "Unsupported OS detected ($ID). This script targets Ubuntu/Debian environments."
        fi
        log_success "Compatible OS detected: $PRETTY_NAME"
    else
        log_error "/etc/os-release not found. Unable to verify operating system."
    fi
}

# Execute if run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_prechecks
fi
