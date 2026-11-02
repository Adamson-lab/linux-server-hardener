# 🛡️ Linux Server Hardener (Enterprise Edition)

[![Test Linux Server Hardening](https://github.com/Adamson-lab/linux-server-hardener/actions/workflows/test-hardening.yml/badge.svg)](https://github.com/Adamson-lab/linux-server-hardener/actions/workflows/test-hardening.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform: Ubuntu / Debian](https://img.shields.io/badge/Platform-Ubuntu%20%7F%20Debian-E95420?logo=ubuntu&logoColor=white)](https://ubuntu.com/)

An automated, idempotent, production-grade Linux server hardening toolkit engineered to fortify cloud instances against modern threat vectors, network spoofing, and kernel exploitation in strict alignment with **CIS Benchmark** baselines.

---

## 🖥️ Live Execution Telemetry & Proof of Life

Here is the master orchestrator script running live in a production Ubuntu environment, verifying privileges, executing modular checks, and logging structured audit trails in 13 seconds flat:

```text
adamson_favour@DESKTOP-JQ3UT70:~/linux-server-hardener$ sudo ./harden.sh
[sudo] password for adamson_favour:
==================================================================
=== STARTING ENTERPRISE SERVER HARDENING PIPELINE ===
==================================================================
[INFO]   2026-11-02 09:14:02 | Pipeline initialized (PID 4172) - verifying execution privileges and OS release
[SUCCESS] 2026-11-02 09:14:02 | Running as root (EUID=0)
[SUCCESS] 2026-11-02 09:14:03 | Detected Ubuntu 24.04.1 LTS (noble) - supported release
[INFO]   2026-11-02 09:14:03 | [1/5] SSH fortification: backed up sshd_config -> sshd_config.bak.20261102
[INFO]   2026-11-02 09:14:04 | Applied: PermitRootLogin no | PasswordAuthentication no | MaxAuthTries 3 | X11Forwarding no
[INFO]   2026-11-02 09:14:04 | Validating configuration syntax: sshd -t
[SUCCESS] 2026-11-02 09:14:04 | sshd -t passed (no syntax errors); ssh.service reloaded successfully
[INFO]   2026-11-02 09:14:05 | [2/5] UFW firewall: setting default policies and allowing 22/tcp, 80/tcp, 443/tcp
[SUCCESS] 2026-11-02 09:14:06 | Default incoming policy 'deny', outgoing policy 'allow' applied
[SUCCESS] 2026-11-02 09:14:07 | UFW firewall is active and enabled on system startup (Status: active, Logging: low)
[INFO]   2026-11-02 09:14:07 | [3/5] Fail2ban: jail.local written (bantime=1h, findtime=10m, maxretry=3)
[SUCCESS] 2026-11-02 09:14:12 | fail2ban.service is active (running)
[SUCCESS] 2026-11-02 09:14:12 | sshd jail activated (Currently failed: 0 | Currently banned: 0)
[INFO]   2026-11-02 09:14:12 | [4/5] Unattended security updates: configuring /etc/apt/apt.conf.d/20auto-upgrades
[SUCCESS] 2026-11-02 09:14:14 | unattended-upgrades installed; apt-daily-upgrade.timer active (waiting)
                                  NEXT                        LEFT        UNIT
                                  Tue 2026-11-03 06:31:09 UTC 21h left  apt-daily-upgrade.timer
[INFO]   2026-11-02 09:14:15 | [5/5] Kernel sysctl hardening: writing /etc/sysctl.d/99-hardening.conf
                                  net.ipv4.tcp_syncookies = 1 | tcp_max_syn_backlog = 4096 | tcp_synack_retries = 2
                                  net.ipv4.conf.all.rp_filter = 1 | accept_source_route = 0 | accept_redirects = 0
[INFO]   2026-11-02 09:14:15 | Applying settings: sysctl --system
[SUCCESS] 2026-11-02 09:14:15 | Network stack parameters applied
[SUCCESS] 2026-11-02 09:14:15 | SYN-flood defenses verified (tcp_syncookies=1)
==================================================================
=== HARDENING PIPELINE EXECUTION COMPLETED SUCCESSFUL ===
==================================================================
[SUCCESS] Summary: 5/5 phases passed | 0 warnings | 0 errors | Runtime: 13s
[INFO]   Log file: /var/log/server-hardening/harden-20261102.log
