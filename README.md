# 🛡️ Linux Server Hardener (Enterprise Edition)

[![Test Linux Server Hardening](https://github.com/Adamson-lab/linux-server-hardener/actions/workflows/test-hardening.yml/badge.svg)](https://github.com/Adamson-lab/linux-server-hardener/actions/workflows/test-hardening.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform: Ubuntu / Debian](https://img.shields.io/badge/Platform-Ubuntu%20%7F%20Debian-E95420?logo=ubuntu&logoColor=white)](https://ubuntu.com/)

An automated, idempotent, production-grade Linux server hardening toolkit engineered to fortify cloud instances against modern threat vectors in alignment with CIS Benchmark baselines.

---

## 🏗️ Architecture & Execution Flow

The automation framework is organized into decoupled, single-responsibility modules orchestrated by a master runner with strict error handling (`set -euo pipefail`).

```mermaid
sequenceDiagram
    autonumber
    participant Admin as Operator / CI
    participant Script as hardening.sh
    participant Pre as 01-Prechecks
    participant SSH as 02-SSH Config
    participant UFW as 03-Firewall
    participant F2B as 04-Fail2ban
    participant Upd as 05-Updates
    
    Admin->>Script: Execute with sudo privileges
    Script->>Pre: Validate root UID & OS compatibility (Ubuntu/Debian)
    Pre-->>Script: Validation Passed
    Script->>SSH: Backup sshd_config & enforce keys-only / disable root
    SSH-->>Script: Syntax validated (sshd -t) & daemon restarted
    Script->>UFW: Set default deny incoming, open SSH/HTTP/HTTPS
    UFW-->>Script: Firewall active & enforcing
    Script->>F2B: Install package & configure SSH brute-force jail
    F2B-->>Script: Intrusion prevention active
    Script->>Upd: Configure unattended-upgrades daily timer
    Upd-->>Script: Security updates automated
    Script-->>Admin: Pipeline Execution Complete
