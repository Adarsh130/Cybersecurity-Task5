# 01 — Project Overview

## Executive Summary

This project represents the practical completion of **Task 5: Capstone Project & Incident Response Simulation**, conducted as part of the Cybersecurity & Ethical Hacking Internship Program with ApexPlanet Software Pvt. Ltd.

The primary objective of this engagement was to conduct a comprehensive security assessment of Damn Vulnerable Web Application (DVWA) hosted within a strictly controlled, isolated local lab on Kali Linux, followed by an end-to-end incident response simulation.

```
+--------------------------------------------------------------------------+
|                  APEXPLANET CYBERSECURITY INTERNSHIP                     |
|                                                                          |
|  Task 1: Foundations & Lab Setup                                         |
|  Task 2: Network Security & Scanning                                     |
|  Task 3: Web Application Security                                        |
|  Task 4: Exploitation & System Security                                  |
|  Task 5: Capstone Project & Incident Response Simulation  <-- [COMPLETED]|
+--------------------------------------------------------------------------+
```

---

## Core Project Highlights

- **Target Application**: Damn Vulnerable Web Application (DVWA) v1.9+ running on Apache HTTP Server 2.4.68 (Debian) with MariaDB backend.
- **Engagement Environment**: Isolated Kali Linux localhost environment (`127.0.0.1:80`), fully air-gapped from production or public networks.
- **Penetration Testing Scope**:
  - Service port scanning and banner identification via Nmap.
  - Web vulnerability and configuration reconnaissance via Nikto.
  - Controlled proof-of-concept testing for 5 critical web application vulnerability classes:
    1. SQL Injection (SQLi)
    2. Reflected Cross-Site Scripting (Reflected XSS)
    3. Stored Cross-Site Scripting (Stored XSS)
    4. Operating System Command Injection
    5. Local File Inclusion (LFI)
- **Incident Response Simulation**:
  - Real-time log triage and attack indicator correlation within `/var/log/apache2/access.log`.
  - Service containment by halting Apache HTTP daemon (`systemctl stop apache2`).
  - Source code remediation using parameterized prepared statements in high-security SQLi module (`high.php`).
  - Web server hardening by disabling directory indexing (`Options -Indexes`), deploying HTTP security headers (`Permissions-Policy`, `Strict-Transport-Security`), and removing exposed repository metadata (`.dockerignore`).
  - Formal post-incident recovery verification and service health auditing (`apache2ctl configtest`, `systemctl is-active apache2 mariadb`).

---

## Repository Index

| Document | Description |
|---|---|
| [01-project-overview.md](01-project-overview.md) | High-level summary of the capstone project and deliverables. |
| [02-scope-and-objectives.md](02-scope-and-objectives.md) | Boundary definition, authorization rules, and engagement goals. |
| [03-lab-architecture.md](03-lab-architecture.md) | System components, network interfaces, and architecture diagrams. |
| [04-reconnaissance.md](04-reconnaissance.md) | Network interface verification, socket auditing, and HTTP discovery. |
| [05-scanning.md](05-scanning.md) | Nmap service scans and Nikto web application vulnerability discovery. |
| [06-vulnerability-testing.md](06-vulnerability-testing.md) | Controlled exploitation tests across SQLi, XSS, Command Injection, and LFI. |
| [07-findings-and-risk.md](07-findings-and-risk.md) | Vulnerability matrix, qualitative risk assessments, and impact analysis. |
| [08-remediation.md](08-remediation.md) | Code refactoring, Apache configuration hardening, and header deployment. |
| [09-incident-response.md](09-incident-response.md) | NIST-aligned IR phases: detection, containment, eradication, and lessons learned. |
| [10-recovery.md](10-recovery.md) | Post-remediation service verification and operational health checks. |
| [11-post-incident-summary.md](11-post-incident-summary.md) | Executive debrief, defensive recommendations, and portfolio takeaways. |
| [Methodology Notes](../notes/methodology.md) | Core testing frameworks, distinction of facts vs. inferences, and workflow. |
