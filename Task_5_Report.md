# Task 5 Capstone Project Completion Report

**Internship Program**: ApexPlanet Cybersecurity & Ethical Hacking Internship Program  
**Task Identifier**: Task 5 — Capstone Project & Incident Response Simulation  
**Reporting Period**: Days 49–60  
**Candidate Name**: Adarsh (Security Intern)  
**Host Organization**: ApexPlanet Software Pvt. Ltd.  
**Target Environment**: Damn Vulnerable Web Application (DVWA v1.9+) on Kali Linux  
**Assessment Date**: September 2026  
**Status**: Completed & 100% Evidence Verified  

---

## 📋 Executive Verification Summary

This completion report formally certifies the completion of **Task 5: Capstone Project & Incident Response Simulation** under the ApexPlanet Cybersecurity & Ethical Hacking Internship Program.

The engagement integrated offensive web application penetration testing with defensive security operations, log forensics, and server hardening. All testing was executed within an authorized, isolated virtual lab on Kali Linux targeting `http://127.0.0.1/DVWA/`.

### Key Metrics & Deliverables
- **Target Application**: DVWA v1.9+ hosted on Apache HTTP Server `2.4.68 (Debian)`.
- **Vulnerabilities Validated**: 5 OWASP Top 10 vulnerabilities (SQLi, Reflected XSS, Stored XSS, OS Command Injection, Local File Inclusion).
- **Incident Response Lifecycle**: Successfully executed Detection, Containment, Eradication, and Recovery phases in alignment with **NIST SP 800-61 Rev. 2**.
- **Defensive Engineering**: Deployed PDO prepared statements, disabled Apache directory indexing (`Options -Indexes`), added HTTP security headers (`HSTS`, `Permissions-Policy`), and quarantined sensitive configuration files.
- **Audit Verification**: Reduced automated scanner alerts (Nikto) by **90.9%** (from 11 items down to 1 informational login item).

---

## 🗂️ Module Completion Breakdown

| Module | Title | Primary Focus | Status | Evidence Reference |
|---|---|---|---|---|
| **Module 1** | Reconnaissance & Fingerprinting | Interface audits (`ip addr`), socket check (`ss -tulpn`), Nmap version scan, baseline Nikto scan | **COMPLETED** | `02-Apache-Port-80.png`, `04-Nmap-Recon-Scan.png`, `06-Nikto-Web-Recon.png` |
| **Module 2** | SQL Injection (SQLi) | Boolean tautology testing (`1' OR '1'='1`), user table dump, database structure analysis | **COMPLETED** | `07-SQLi-Baseline.png`, `08-SQLi-Vulnerable-Response.png` |
| **Module 3** | Cross-Site Scripting (XSS) | Reflected XSS input testing and Stored XSS persistent database trap in guestbook | **COMPLETED** | `09-XSS-Reflected-Alert.png`, `10-XSS-Stored-Alert.png` |
| **Module 4** | OS Command Injection | Shell metacharacter injection (`; whoami`), identity discovery (`www-data`) | **COMPLETED** | `11-Command-Injection-Baseline.png`, `12-Command-Injection-Executed.png` |
| **Module 5** | Local File Inclusion (LFI) | Directory traversal sequences (`../../../../etc/passwd`), system user exposure | **COMPLETED** | `13-LFI-Etc-Passwd.png` |
| **Module 6** | Incident Detection & Log Forensics | Real-time monitoring of `/var/log/apache2/access.log`, forensic regular expression filtering | **COMPLETED** | `14-Apache-Attack-Logs.png`, `15-Suspicious-Attack-Logs.png` |
| **Module 7** | Service Containment & Hardening | Emergency isolation (`systemctl stop apache2`), prepared statements, `Options -Indexes`, headers | **COMPLETED** | `16-Incident-Containment.png`, `24-Config-Test.png`, `25-Applied.png` |
| **Module 8** | Recovery & Verification | Service health audits (`apache2`, `mariadb`), multi-stage Nikto rescan progression | **COMPLETED** | `26-Nikto-Fix.png`, `33-Dockerignore.png`, `35-Recovery.png` |

---

## 📑 Repository Documentation Links
- **Master README Portfolio**: [`README.md`](README.md)
- **Comprehensive Technical Report**: [`Incident_Response_and_Penetration_Testing_Report.md`](Incident_Response_and_Penetration_Testing_Report.md)
- **Granular Phase Reports**: [`docs/`](docs/)
- **Defensive Mitigation Scripts**: [`mitigations/`](mitigations/)
- **Video Presentation Script**: [`demo/demo-script.md`](demo/demo-script.md)

---

## ✍️ Verification & Sign-off

I hereby confirm that all security testing, incident response procedures, code refactoring, and server hardening actions documented in this report were executed personally within an authorized local laboratory environment, adhering to professional ethical hacking standards.

**Candidate Signature**: Adarsh (Security Intern)  
**Date**: September 6, 2026  
**Program**: ApexPlanet Cybersecurity & Ethical Hacking Internship
