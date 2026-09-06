# Security Assessment & Incident Response Methodology

## 1. Overview

This document defines the structured methodology employed for **Task 5: Web Application Penetration Testing & Incident Response Simulation on DVWA**. 

The engagement followed industry-recognized frameworks, specifically adapting principles from the **OWASP Web Security Testing Guide (WSTG v4.2)**, the **Penetration Testing Execution Standard (PTES)**, and the **NIST Special Publication 800-61 Rev. 2 (Computer Security Incident Handling Guide)**.

---

## 2. Guiding Principles & Epistemological Framework

To maintain strict professional and academic integrity, all observations in this repository adhere to the following triad of categorization:

| Level | Definition | Application in This Engagement |
|---|---|---|
| **OBSERVED FACT** | Verifiable data directly recorded from terminal outputs, network captures, browser alerts, or server logs. | Terminal outputs (`Syntax OK`, `www-data`), HTTP status codes (200, 302, 404), log entries, screenshot evidence. |
| **INFERENCE** | Logical deduction derived from observed facts based on protocol specifications or software behavior. | Deducing that Apache executes child processes under the `www-data` service account because `whoami` returned `www-data`. |
| **RECOMMENDATION** | Industry best-practice controls proposed to address root-cause weaknesses. | Enforcing parameterized queries via prepared statements, disabling directory indexing, and deploying HTTP security headers. |

---

## 3. Penetration Testing Lifecycle

### Phase 1: Planning & Pre-Engagement
- **Scope Definition**: Testing strictly limited to local target `http://127.0.0.1/DVWA/` on Kali Linux. External network interactions are prohibited.
- **Rules of Engagement (RoE)**: Controlled payloads only; no denial-of-service, non-destructive file reading, and harmless JavaScript dialog execution (`alert()`).

### Phase 2: Reconnaissance & Target Discovery
- **Interface & Route Verification**: Checking active IP bindings and network adapters via `ip addr`.
- **Socket & Service Auditing**: Probing active listening sockets using `ss -tulpn | grep -E ':80|:443'`.
- **Endpoint Reachability**: Validating HTTP headers and redirects via `curl -I http://127.0.0.1/DVWA/`.

### Phase 3: Vulnerability Scanning & Information Gathering
- **Port & Version Identification**: Running targeted TCP service detection with `nmap -sV -p 80,443 127.0.0.1`.
- **Web Application Reconnaissance**: Running `nikto -h http://127.0.0.1/DVWA/` to flag missing HTTP headers, exposed directories (CWE-548), and sensitive repository artifacts.

### Phase 4: Controlled Exploitation & Vulnerability Verification
Each vulnerability category was evaluated using a controlled, deterministic test case:
1. **SQL Injection (SQLi)**:
   - Baseline query validation: Submitting standard `User ID: 1`.
   - Injection test: Submitting boolean-based tautology `1' OR '1'='1` to evaluate query concatenation in the data layer.
   - Code Review: Static analysis of `high.php` via `sed` to verify raw session variable interpolation into dynamic SQL query strings.
2. **Reflected Cross-Site Scripting (Reflected XSS)**:
   - Injecting inline JavaScript string payload `<script>alert('DVWA-XSS-Test')</script>` into the GET `name` parameter.
   - Verifying script execution in the Document Object Model (DOM).
3. **Stored Cross-Site Scripting (Stored XSS)**:
   - Submitting persistent guestbook entry with payload `<script>alert('DVWA-Stored-XSS')</script>`.
   - Verifying execution persistence upon page reload.
4. **Command Injection**:
   - Submitting combined command sequence `127.0.0.1; whoami` into the IP ping form.
   - Validating execution of shell command under web server process context.
5. **Local File Inclusion (LFI)**:
   - Submitting path traversal sequences `../../../../etc/passwd` and absolute path `/etc/passwd` via parameter `page`.
   - Observing unauthorized file disclosure from the underlying Linux filesystem.

---

## 4. Incident Response Simulation Framework (NIST SP 800-61 Rev. 2 Aligned)

```
+-------------------------------------------------------------+
|                      1. DETECTION                           |
|  Inspect /var/log/apache2/access.log using tail & grep      |
+------------------------------+------------------------------+
                               |
                               v
+-------------------------------------------------------------+
|                     2. INITIAL ANALYSIS                     |
|  Correlate client IP, timestamps, URIs, and attack vectors  |
+------------------------------+------------------------------+
                               |
                               v
+-------------------------------------------------------------+
|                     3. CONTAINMENT                          |
|  Immediate service isolation: systemctl stop apache2        |
+------------------------------+------------------------------+
                               |
                               v
+-------------------------------------------------------------+
|              4. ERADICATION & HARDENING                     |
|  Patch High SQLi code | Disable Indexes | Set Headers       |
|  Isolate .dockerignore from web root                        |
+------------------------------+------------------------------+
                               |
                               v
+-------------------------------------------------------------+
|                     5. RECOVERY & VERIFICATION              |
|  Config validation (apache2ctl configtest)                  |
|  Service restart & status audit (systemctl is-active)       |
|  Verification scanning via Nikto and curl                   |
+------------------------------+------------------------------+
                               |
                               v
+-------------------------------------------------------------+
|                   6. POST-INCIDENT SUMMARY                  |
|  Document findings, residual risk, and lessons learned      |
+-------------------------------------------------------------+
```

### Phase 1: Detection
- Real-time log monitoring: Using `tail -n 30 /var/log/apache2/access.log`.
- Pattern-based log triage: Filtering suspicious attack signatures using regex via:
  ```bash
  sudo grep -Ei "etc/passwd|union|select|script|or.*=|cmd|127\.0\.0\.1" /var/log/apache2/access.log | tail -n 30
  ```

### Phase 2: Containment
- Rapid isolation of the vulnerable vector: Halting HTTP service via `systemctl stop apache2`.
- Verification of inactive service state via `systemctl is-active apache2`.

### Phase 3: Eradication & Hardening
- **Code Remediation**: Modifying vulnerable source code to utilize prepared statements and output encoding.
- **Server Configuration Hardening**: Restricting directory indexing (`Options -Indexes`).
- **Defense-in-Depth Headers**: Enforcing `Permissions-Policy` and `Strict-Transport-Security`.
- **Sensitive Artifact Isolation**: Removing `.dockerignore` from the public web document tree.

### Phase 4: Recovery & Operational Verification
- Pre-flight configuration testing: `apache2ctl configtest` ensuring `Syntax OK`.
- Controlled service restoration: `systemctl restart apache2` and `systemctl is-active apache2 mariadb`.
- Post-remediation automated rescans via Nikto to confirm clearance of identified misconfigurations.
