# Formal Web Application Penetration Testing & Incident Response Report

**Document Title**: Comprehensive Security Assessment & Incident Response Simulation Report  
**Target System**: Damn Vulnerable Web Application (DVWA v1.9+)  
**Host Platform**: Kali Linux (Linux 6.x Kernel / Debian-based)  
**Host Organization**: ApexPlanet Software Pvt. Ltd.  
**Engagement Frameworks**: OWASP Web Security Testing Guide (WSTG v4.2) & NIST SP 800-61 Rev. 2  
**Lead Security Assessor**: Adarsh (Cybersecurity Intern)  
**Report Date**: September 6, 2026  
**Classification**: Academic & Professional Portfolio / Internal Assessment  

---

## 1. Executive Summary

During the period of Days 49–60 of the ApexPlanet Cybersecurity & Ethical Hacking Internship Program, an authorized, comprehensive web application penetration testing assessment and simulated incident response procedure was conducted against Damn Vulnerable Web Application (DVWA v1.9+) deployed locally at `http://127.0.0.1/DVWA/`.

The assessment identified multiple critical security vulnerabilities categorized under the **OWASP Top 10 (2021)**:
1. **OS Command Injection (CWE-78)**: Arbitrary command execution with `www-data` privileges.
2. **SQL Injection (CWE-89)**: Unauthenticated relational database extraction via boolean logic manipulation.
3. **Local File Inclusion (CWE-22)**: Operating system file disclosure via directory traversal.
4. **Cross-Site Scripting (CWE-79)**: Both Reflected and Persistent client-side script execution.
5. **Security Misconfigurations (CWE-548, CWE-538, CWE-1021)**: Unrestricted directory listings, exposed build artifacts (`.dockerignore`), and missing browser security headers.

Following vulnerability confirmation, an incident response simulation in accordance with **NIST SP 800-61 Rev. 2** was executed. The incident was detected through log forensics on `/var/log/apache2/access.log`, contained by isolating the web daemon (`systemctl stop apache2`), eradicated through code refactoring (PDO prepared statements) and server configuration hardening (`Options -Indexes`, security headers), and verified through service restoration and multi-stage Nikto rescan audits. Automated scanner alerts dropped from **11 items to 1 informational item**, achieving a **90.9% reduction in exploitable surface alerts**.

---

## 2. Assessment Scope & Authorization

- **Primary Target**: `http://127.0.0.1/DVWA/` (Loopback interface `lo` on Kali Linux).
- **Service Scope**: TCP port 80 (Apache `2.4.68 (Debian)`), MariaDB backend on port 3306.
- **Rules of Engagement**: Non-destructive offensive testing. All activities restricted strictly to the virtual host. No external network scanning or denial-of-service tests were authorized or performed.

---

## 3. Comprehensive Vulnerability Matrix

| ID | Vulnerability Title | Severity | CVSS v3.1 | CWE | Affected Component | Status |
|---|---|---|---|---|---|---|
| **VULN-01** | OS Command Injection | `CRITICAL` | **9.8** | CWE-78 | `/DVWA/vulnerabilities/exec/` | Controlled PoC verified |
| **VULN-02** | SQL Injection (Boolean-Based) | `HIGH` | **8.6** | CWE-89 | `/DVWA/vulnerabilities/sqli/` | Remediated via Prepared Statements |
| **VULN-03** | Local File Inclusion (LFI) | `HIGH` | **7.5** | CWE-22 | `/DVWA/vulnerabilities/fi/` | Controlled PoC verified |
| **VULN-04** | Stored Cross-Site Scripting | `MEDIUM` | **6.1** | CWE-79 | `/DVWA/vulnerabilities/xss_s/` | Controlled PoC verified |
| **VULN-05** | Reflected Cross-Site Scripting | `MEDIUM` | **6.1** | CWE-79 | `/DVWA/vulnerabilities/xss_r/` | Controlled PoC verified |
| **VULN-06** | Directory Indexing (Information Disclosure) | `MEDIUM` | **5.3** | CWE-548 | `/DVWA/config/`, `/tests/`, etc. | **100% Remediated** (`Options -Indexes`) |
| **VULN-07** | Sensitive Build Artifact Exposure | `LOW` | **3.7** | CWE-538 | `/DVWA/.dockerignore` | **100% Remediated** (404 Confirmed) |
| **VULN-08** | Missing HTTP Security Headers | `LOW` | **3.1** | CWE-1021| HTTP Response Headers | **100% Remediated** (HSTS & Policy Set) |

---

## 4. Incident Response Lifecycle Walkthrough

### Phase 1: Preparation
Baseline server metrics, logging levels, and configuration backups were verified before testing.

### Phase 2: Detection & Analysis
Log triage of `/var/log/apache2/access.log` using forensic regular expressions identified anomalous HTTP GET and POST requests originating from `127.0.0.1` containing SQL syntax (`' OR '1'='1`), directory traversals (`../../../../etc/passwd`), and script injection patterns.

### Phase 3: Containment
The incident commander initiated immediate host isolation by disabling the Apache service:
```bash
systemctl stop apache2
systemctl is-active apache2 # Returns "inactive"
```
This closed listening socket `*:80` and dropped active connections, neutralizing active exploitation channels.

### Phase 4: Eradication
- Refactored `high.php` to utilize PDO parameterized queries; verified syntax with `php -l`.
- Updated `/etc/apache2/sites-available/000-default.conf` with `Options -Indexes +FollowSymLinks`; validated with `apache2ctl configtest`.
- Injected `Strict-Transport-Security` and `Permissions-Policy` response headers.
- Relocated `.dockerignore` to `.dockerignore.bak` outside public web accessibility.

### Phase 5: Recovery & Verification
- Restored `apache2` and `mariadb` services (`active`).
- Executed consecutive Nikto audits: findings dropped from 11 items to 4, then to 2, and finally to 1 single informational item (`/DVWA/login.php`), validating complete remediation of actionable misconfigurations.

### Phase 6: Post-Incident Lessons Learned
Key operational findings:
- Separation of code and data via parameterized queries eliminates SQL injection completely.
- Web middleware must have security baselines enforced during deployment.
- Centralized log streaming to a SIEM is essential for real-time alerting and incident response.

---

## 5. Enterprise Hardening Recommendations

1. **Web Application Firewall (WAF)**: Deploy ModSecurity with the OWASP Core Rule Set (CRS) in front of the web application.
2. **Centralized Log Management**: Ship web server logs to a dedicated SIEM (e.g., Wazuh or Elastic SIEM) for real-time anomaly detection.
3. **CI/CD DevSecOps**: Integrate Semgrep (SAST) and OWASP ZAP (DAST) into deployment pipelines to block vulnerabilities before production release.
4. **Least Privilege**: Restrict the web server execution user (`www-data`) from executing shell binaries or reading unauthorized system files.
