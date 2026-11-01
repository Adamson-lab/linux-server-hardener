#!/usr/bin/env bash
# ==============================================================================
# Master Script: Linux Server Hardening Orchestrator
# Author: Favour Adamson (Adamson-lab)
# Description: Orchestrates modular server security enforcement.
# ==============================================================================

set -euo pipefail

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_header() {
    echo -e "\n${BLUE}==================================================================${NC}"
    echo -e "${BLUE}=== $1 ${NC}"
    echo -e "${BLUE}==================================================================${NC}"
}

log_info() { echo -e "${YELLOW}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Locate script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULES_DIR="$SCRIPT_DIR/modules"

log_header "STARTING ENTERPRISE SERVER HARDENING PIPELINE"

# 1. Execute Pre-checks
if [[ -f "$MODULES_DIR/01-prechecks.sh" ]]; then
    log_info "Executing Pre-flight Checks..."
    bash "$MODULES_DIR/01-prechecks.sh"
else
    log_error "Pre-checks module not found at $MODULES_DIR/01-prechecks.sh"
fi

# 2. Execute SSH Hardening
if [[ -f "$MODULES_DIR/02-ssh.sh" ]]; then
    log_header "MODULE: SSH FORTIFICATION"
    bash "$MODULES_DIR/02-ssh.sh"
else
    log_error "SSH module not found."
fi

log_header "HARDENING PIPELINE EXECUTION COMPLETED SUCCESSFULLY"
