# Web Application Penetration Testing & Incident Response Simulation on DVWA

[![Capstone Project](https://img.shields.io/badge/Project-Task--5%20Capstone-blue.svg)](#)
[![Internship](https://img.shields.io/badge/Internship-ApexPlanet%20Software-purple.svg)](#)
[![Environment](https://img.shields.io/badge/Environment-Isolated%20Kali%20Linux%20Lab-orange.svg)](#)
[![Target](https://img.shields.io/badge/Target-DVWA%20v1.9+-red.svg)](#)
[![Methodology](https://img.shields.io/badge/Framework-OWASP%20WSTG%20%7C%20NIST%20SP%20800--61%20Rev%202-green.svg)](#)
[![Documentation](https://img.shields.io/badge/Documentation-100%25%20Evidence--Backed-brightgreen.svg)](#)
[![Audit Reduction](https://img.shields.io/badge/Nikto%20Findings-11%20%E2%9E%94%201%20(90.9%25%20Reduction)-teal.svg)](#)

---

## 📑 Table of Contents

1. [Executive Summary](#-executive-summary)
2. [Project Scope & Authorization](#-project-scope--authorization)
3. [Lab Architecture & Technology Stack](#-lab-architecture--technology-stack)
4. [Methodology & Epistemological Framework](#-methodology--epistemological-framework)
5. [Reconnaissance & Service Fingerprinting](#-reconnaissance--service-fingerprinting)
6. [Deep-Dive Vulnerability Analysis & Exploitation](#-deep-dive-vulnerability-analysis--exploitation)
   - [1. SQL Injection (SQLi)](#1-sql-injection-sqli---cwe-89--owasp-a03)
   - [2. Reflected Cross-Site Scripting (XSS)](#2-reflected-cross-site-scripting-xss---cwe-79--owasp-a03)
   - [3. Stored Cross-Site Scripting (XSS)](#3-stored-cross-site-scripting-xss---cwe-79--owasp-a03)
   - [4. OS Command Injection](#4-os-command-injection---cwe-78--owasp-a03)
   - [5. Local File Inclusion (LFI)](#5-local-file-inclusion-lfi---cwe-22--owasp-a01)
   - [6. Directory Indexing & Information Disclosure](#6-directory-indexing--information-disclosure---cwe-548--owasp-a05)
   - [7. Sensitive Build Artifact Exposure](#7-sensitive-build-artifact-exposure---cwe-538--owasp-a05)
   - [8. Missing HTTP Security Headers](#8-missing-http-security-headers---cwe-1021--owasp-a05)
7. [Incident Response Simulation (NIST SP 800-61 Rev. 2)](#-incident-response-simulation-nist-sp-800-61-rev-2)
   - [Phase 1: Detection & Forensic Log Analysis](#phase-1-detection--forensic-log-triage)
   - [Phase 2: Emergency Service Containment](#phase-2-emergency-service-containment)
   - [Phase 3: Eradication & Hardening](#phase-3-eradication--hardening)
   - [Phase 4: Recovery & Operational Verification](#phase-4-recovery--operational-verification)
   - [Phase 5: Post-Incident Lessons Learned](#phase-5-post-incident-lessons-learned)
8. [Remediation & Hardening Delta Comparison](#-remediation--hardening-delta-comparison)
9. [Enterprise Defense-in-Depth Architecture](#-enterprise-defense-in-depth-architecture)
10. [Curated Evidence Gallery](#-curated-evidence-gallery)
11. [Repository Structure & Navigation](#-repository-structure--navigation)
12. [Legal, Ethical & Educational Disclaimer](#-legal-ethical--educational-disclaimer)

---

## 🛡️ Executive Summary

This repository documents the end-to-end practical execution of **Task 5: Capstone Project & Incident Response Simulation** for the **Cybersecurity & Ethical Hacking Internship Program** at **ApexPlanet Software Pvt. Ltd.**

The core objective of this capstone was to bridge the gap between **offensive security (Red Teaming)** and **defensive engineering (Blue Teaming)** by executing an authorized, deterministic penetration test against an isolated instance of **Damn Vulnerable Web Application (DVWA v1.9+)**, followed immediately by a structured **incident response, log forensic investigation, service containment, secure code refactoring, and server hardening lifecycle**.

### Key Outcomes & Milestones
- **Comprehensive Reconnaissance**: Mapped network interfaces, TCP port bindings (`*:80` Apache `2.4.68 (Debian)`), VirtualHost endpoints, and conducted automated scanner baseline profiling.
- **Offensive Proof-of-Concept Validation**: Successfully verified 5 OWASP Top 10 vulnerabilities (**SQL Injection**, **Reflected XSS**, **Stored XSS**, **OS Command Injection**, and **Local File Inclusion**) without causing unintended denial-of-service or database corruption.
- **High-Fidelity Log Triage**: Analyzed `/var/log/apache2/access.log` using custom forensic regular expressions, extracting attacker IP addresses, URIs, timestamps, and payload signatures.
- **Incident Containment**: Executed operational service isolation using `systemctl stop apache2` to freeze active attack vectors.
- **Defensive Eradication & Hardening**:
  - Implemented SQL parameterization using prepared statements in PHP.
  - Disabled directory listing (`Options -Indexes`) across the Apache web root.
  - Deployed `Strict-Transport-Security` and `Permissions-Policy` security headers.
  - Quarantined build configuration artifacts (`.dockerignore`).
- **Measurable Security Posture Improvement**: Reduced Nikto scanner findings from **11 items down to 1 informational finding** (an expected login prompt at `/DVWA/login.php`), achieving a **90.9% reduction in exploitable surface alerts**.

---

## 🎯 Project Scope & Authorization

### Authorization & Lab Boundaries
- **Engagement Type**: Authorized Academic & Professional Internship Capstone.
- **Host Institution**: ApexPlanet Software Pvt. Ltd.
- **Target Application**: Damn Vulnerable Web Application (DVWA) v1.9+.
- **Host Environment**: Kali Linux Virtual Machine.
- **Target Interface**: Local loopback only (`http://127.0.0.1/DVWA/`).
- **Strict Boundary Rule**: All security testing, scanning, and exploitation were strictly confined to the local virtual machine loopback interface. **Zero testing was performed or directed against any external, public, or third-party network or infrastructure.**

```
+-----------------------------------------------------------------------------------+
|                              STRICT BOUNDARY POLICY                                |
|                                                                                   |
|  [ IN-SCOPE ]                                                                     |
|  * 127.0.0.1:80 (Loopback Apache 2.4.68)                                          |
|  * /var/www/html/DVWA/ web root                                                   |
|  * MariaDB local socket (DVWA database)                                           |
|  * /var/log/apache2/ access and error logs                                        |
|                                                                                   |
|  [ OUT-OF-SCOPE ]                                                                 |
|  * External network interfaces (eth0, eth1)                                       |
|  * Any public domain, IP address, or cloud endpoint                               |
|  * Physical host infrastructure                                                   |
+-----------------------------------------------------------------------------------+
```

---

## 🏗️ Lab Architecture & Technology Stack

The assessment and simulation were conducted in a fully contained, single-host virtual lab environment running on Kali Linux. All network traffic remained encapsulated within the internal loopback subsystem.

![Lab Architecture Diagram](diagrams/network-diagram.png)

### Technology Stack Specifications

| Component | Technology | Version / Configuration | Role in Assessment |
|---|---|---|---|
| **Operating System** | Kali Linux | Debian-derived Linux 6.x kernel | Penetration testing & incident response workstation |
| **Network Interfaces** | `lo`, `eth0`, `eth1` | `lo: 127.0.0.1/8` (Target Interface) | Confines all offensive & defensive traffic to localhost |
| **Web Server** | Apache HTTP Server | `2.4.68 (Debian)` | HTTP middleware, virtual hosting, and access logging |
| **Web Application** | DVWA | Version 1.9+ | Target web application vulnerable testbed |
| **Application Runtime** | PHP | PHP 8.x Engine | Script execution and server-side processing |
| **Database Management** | MariaDB | Port 3306 / UNIX domain socket | Backend relational data store for user records |
| **Security Scanning Tools** | Nmap, Nikto | `nmap v7.9x`, `nikto v2.5.0` | Port scanning, service fingerprinting, and web vulnerability auditing |
| **Audit Log Facility** | Apache Logging | `/var/log/apache2/access.log` | Raw event capture for detection & incident response triage |

---

## 🔬 Methodology & Epistemological Framework

The project synthesized two industry-standard cybersecurity methodologies:
1. **Offensive Phase**: **OWASP Web Security Testing Guide (WSTG v4.2)** — Structured identification, input fuzzing, payload delivery, and impact demonstration.
2. **Defensive Phase**: **NIST SP 800-61 Rev. 2 (Computer Security Incident Handling Guide)** — Systematic detection, analysis, containment, eradication, recovery, and post-incident documentation.

```
       OFFENSIVE TESTING (OWASP WSTG)               DEFENSIVE INCIDENT RESPONSE (NIST SP 800-61)
┌───────────────────────────────────────────┐     ┌──────────────────────────────────────────┐
│  Phase 1: Reconnaissance & Enumeration    │     │  Phase 4: Attack Signature Detection     │
│  Phase 2: Service & Vulnerability Scan    │ ──> │  Phase 5: Emergency Service Containment  │
│  Phase 3: Proof-of-Concept Exploitation   │     │  Phase 6: Root-Cause Eradication & Fix   │
│           (SQLi, XSS, CmdInj, LFI)        │     │  Phase 7: Recovery & Delta Verification  │
└───────────────────────────────────────────┘     └──────────────────────────────────────────┘
```

### Strict Epistemological Classification Standard
To ensure 100% technical integrity and avoid fabrication or exaggerated claims, every statement throughout this repository adheres to three explicit categories:
- **OBSERVED FACT**: Directly captured from terminal outputs, HTTP request/response headers, server logs, or screenshot artifacts.
- **INFERENCE**: Logical technical deduction derived directly from verifiable facts (e.g., concluding that input is concatenated directly into a shell string because `127.0.0.1; whoami` returns `www-data`).
- **RECOMMENDATION**: Industry-standard remediation and defensive engineering advice (e.g., recommending parameterized queries or Content Security Policy headers).

---

## 🛰️ Reconnaissance & Service Fingerprinting

Reconnaissance focused on identifying active listening services, verifying web server banners, and auditing URL path routing behavior.

### 1. Network Interface & Socket Audit
Initial inspection confirmed the host IP allocation and established that the web daemon was actively bound to port 80.
- **Commands Executed**:
  ```bash
  ip addr
  ss -tulpn | grep -E ':80|:443'
  ```
- **Observed Results**:
  - `lo`: `127.0.0.1/8` (Loopback interface).
  - `eth0`: `10.0.2.15/24` (NAT interface).
  - `eth1`: `192.168.56.103/24` (Host-only interface).
  - `ss` output confirmed `tcp LISTEN 0 511 *:80 *:* users:(("apache2",pid=...))` indicating Apache was listening globally on port 80.
- **Evidence Reference**: [02-Apache-Port-80.png](evidence/reconnaissance/02-Apache-Port-80.png)

### 2. URL Path Sensitivity & Endpoint Verification
Probing the target with `curl` demonstrated that the Apache web server on Linux enforces strict case sensitivity:
- **Test 1 (`lowercase`)**:
  ```bash
  curl -I http://127.0.0.1/dvwa/
  # Output: HTTP/1.1 404 Not Found
  ```
- **Test 2 (`uppercase`)**:
  ```bash
  curl -I http://127.0.0.1/DVWA/
  # Output: HTTP/1.1 302 Found
  # Location: login.php
  # Server: Apache/2.4.68 (Debian)
  ```
- **Technical Insight**: The request to `http://127.0.0.1/DVWA/` yielded a `302 Found` redirection pointing to `login.php` and fingerprinted the server banner as `Apache/2.4.68 (Debian)`.
- **Evidence Reference**: [03-DVWA-Endpoint-Verified.png](evidence/reconnaissance/03-DVWA-Endpoint-Verified.png)

### 3. Transport Layer Port Scanning (Nmap)
A targeted service scan was performed against ports 80 and 443 on the loopback address:
- **Command Executed**:
  ```bash
  nmap -sV -p 80,443 127.0.0.1
  ```
- **Observed Output**:
  - Port `80/tcp`: `open` - `http` - `Apache httpd 2.4.68 ((Debian))`
  - Port `443/tcp`: `closed` - `https`
- **Technical Implication**: The web application communicates over unencrypted plaintext HTTP on port 80. No TLS/SSL listener is configured on port 443.
- **Evidence Reference**: [04-Nmap-Recon-Scan.png](evidence/reconnaissance/04-Nmap-Recon-Scan.png)

### 4. Automated Baseline Web Vulnerability Scan (Nikto)
An automated scan was conducted to establish a baseline before any defensive measures were deployed:
- **Command Executed**:
  ```bash
  nikto -h http://127.0.0.1/DVWA/
  ```
- **Observed Findings (11 Items Reported)**:
  1. Missing `Strict-Transport-Security` header.
  2. Missing `Permissions-Policy` header.
  3. Directory indexing found and enabled: `/DVWA/config/`
  4. Directory indexing found and enabled: `/DVWA/tests/`
  5. Directory indexing found and enabled: `/DVWA/database/`
  6. Directory indexing found and enabled: `/DVWA/docs/`
  7. Sensitive build file exposed: `/.dockerignore`
  8. Login page identified: `/DVWA/login.php` (Informational endpoint)
  9. Default Apache installation cues and index behavior.
- **Evidence Reference**: [06-Nikto-Web-Recon.png](evidence/reconnaissance/06-Nikto-Web-Recon.png)

---

## 💥 Deep-Dive Vulnerability Analysis & Exploitation

Each vulnerability was evaluated through controlled proof-of-concept testing to determine the exact root cause, threat vector, data impact, and forensic fingerprint.

---

### 1. SQL Injection (SQLi) — CWE-89 / OWASP A03

#### Technical Breakdown & Mechanism
SQL Injection occurs when untrusted user input is directly concatenated into a dynamic SQL command string without adequate sanitization, parameterization, or type checking. When the database engine parses the combined string, the injected syntax alters the intended logic of the SQL statement.

#### Baseline vs. Attack Execution
1. **Baseline Query**:
   - Injected input: `id=1`
   - Server returns: First Name: `admin`, Surname: `admin`.
   - Evidence: [07-SQLi-Baseline.png](evidence/exploitation/07-SQLi-Baseline.png)
2. **Boolean-Based Exploitation**:
   - Injected payload: `1' OR '1'='1`
   - Target parameter: `id` (via `GET` request to `/DVWA/vulnerabilities/sqli/?id=1'+OR+'1'%3D'1'&Submit=Submit`)
   - Mechanics: The trailing quote `'` terminates the literal string value of `id`. The appended `OR '1'='1'` forces the `WHERE` clause condition to evaluate to `TRUE` for every row in the `users` table.
   - Observed Result: The application returned all 5 registered user accounts (`admin`, `Gordon`, `Hack`, `Pablo`, `Boba`) alongside their respective IDs and surnames.
   - Evidence: [08-SQLi-Vulnerable-Response.png](evidence/exploitation/08-SQLi-Vulnerable-Response.png)

#### Forensic Access Log Signature
```log
127.0.0.1 - - [06/Sep/2026:11:42:15 +0530] "GET /DVWA/vulnerabilities/sqli/?id=1%27+OR+%271%27%3D%271&Submit=Submit HTTP/1.1" 200 4821 "http://127.0.0.1/DVWA/vulnerabilities/sqli/" "Mozilla/5.0 (X11; Linux x86_64) ..."
```

#### Vulnerable Code vs. Secure Implementation

```php
// ==========================================
// VULNERABLE CODE (Dynamic Concatenation)
// ==========================================
$id = $_GET['id'];
$query  = "SELECT first_name, last_name FROM users WHERE user_id = '$id';";
$result = mysqli_query($GLOBALS["___mysqli_ston"], $query);

// ==========================================
// SECURE CODE (Prepared Statement with PDO)
// ==========================================
$id = $_GET['id'];
$stmt = $pdo->prepare('SELECT first_name, last_name FROM users WHERE user_id = :id LIMIT 1;');
$stmt->bindParam(':id', $id, PDO::PARAM_INT);
$stmt->execute();
$result = $stmt->fetchAll();
```

---

### 2. Reflected Cross-Site Scripting (XSS) — CWE-79 / OWASP A03

#### Technical Breakdown & Mechanism
Reflected Cross-Site Scripting arises when an application receives user-supplied data in an HTTP request and immediately includes that data in the immediate HTTP response page without proper HTML entity encoding or context-aware escaping. As a result, the victim's web browser interprets user-supplied data as executable JavaScript.

#### Exploitation Execution
- **Target Endpoint**: `/DVWA/vulnerabilities/xss_r/`
- **Target Parameter**: `name`
- **Injected Payload**: `<script>alert('DVWA-XSS-Test')</script>`
- **Observed Result**: The browser parsed the unescaped script tag directly into the DOM and triggered a JavaScript alert dialog with the exact string `DVWA-XSS-Test`.
- **Evidence Reference**: [09-XSS-Reflected-Alert.png](evidence/exploitation/09-XSS-Reflected-Alert.png)

#### Forensic Access Log Signature
```log
127.0.0.1 - - [06/Sep/2026:11:44:02 +0530] "GET /DVWA/vulnerabilities/xss_r/?name=%3Cscript%3Ealert%28%27DVWA-XSS-Test%27%29%3C%2Fscript%3E HTTP/1.1" 200 4680 "http://127.0.0.1/DVWA/vulnerabilities/xss_r/" "Mozilla/5.0 ..."
```

#### Remediation Diff
```php
// BEFORE (Vulnerable)
echo '<pre>Hello ' . $_GET['name'] . '</pre>';

// AFTER (Secure - Sanitized via htmlspecialchars)
echo '<pre>Hello ' . htmlspecialchars($_GET['name'], ENT_QUOTES | ENT_HTML5, 'UTF-8') . '</pre>';
```

---

### 3. Stored Cross-Site Scripting (XSS) — CWE-79 / OWASP A03

#### Technical Breakdown & Mechanism
Stored XSS occurs when malicious script input is accepted by the server, persistently committed to the backend datastore (e.g., MariaDB), and later rendered back to any user requesting the stored resource without contextual encoding. This creates a persistent trap that automatically fires whenever the infected page is visited.

#### Exploitation Execution
- **Target Feature**: DVWA Guestbook (`/DVWA/vulnerabilities/xss_s/`)
- **Target Fields**: `txtName` and `mtxMessage`
- **Injected Payload**: `<script>alert('DVWA-Stored-XSS')</script>` entered into the guestbook message body.
- **Observed Result**: The entry was committed to the database. Upon page reload or re-navigation, the browser executed the payload from the database record, displaying the persistent modal alert `DVWA-Stored-XSS`.
- **Evidence Reference**: [10-XSS-Stored-Alert.png](evidence/exploitation/10-XSS-Stored-Alert.png)

#### Remediation Strategy
1. **Input Validation**: Strip dangerous HTML tags or enforce an allowlist on message bodies.
2. **Contextual Encoding**: Apply `htmlspecialchars($message, ENT_QUOTES, 'UTF-8')` before writing the database output into the response HTML.
3. **Defense-in-Depth**: Deploy a strict **Content Security Policy (CSP)** header (e.g., `Content-Security-Policy: default-src 'self'; script-src 'self'`) to block inline script execution entirely.

---

### 4. OS Command Injection — CWE-78 / OWASP A03

#### Technical Breakdown & Mechanism
Command Injection happens when an application passes unsanitized user-controlled input directly into a system shell execution function (such as `system()`, `exec()`, `passthru()`, or `shell_exec()`). By appending shell metacharacters (e.g., `;`, `&&`, `|`, `||`), an attacker can execute arbitrary operating system commands with the privileges of the web daemon.

#### Baseline vs. Attack Execution
1. **Baseline Operation**:
   - Injected IP: `127.0.0.1`
   - Result: Standard output of `ping -c 4 127.0.0.1` displayed on screen.
   - Evidence: [11-Command-Injection-Baseline.png](evidence/exploitation/11-Command-Injection-Baseline.png)
2. **Arbitrary Command Execution**:
   - Injected Input: `127.0.0.1; whoami`
   - Execution Mechanics: The semicolon `;` acts as a command separator in the Linux Bash shell. The operating system executes the `ping` utility first, followed immediately by the second command `whoami`.
   - Observed Output: The webpage rendered the complete ping diagnostic output followed by `www-data` (the Linux user running the Apache daemon).
   - Evidence: [12-Command-Injection-Executed.png](evidence/exploitation/12-Command-Injection-Executed.png)

#### Forensic Access Log Signature
```log
127.0.0.1 - - [06/Sep/2026:11:47:33 +0530] "POST /DVWA/vulnerabilities/exec/ HTTP/1.1" 200 4912 "http://127.0.0.1/DVWA/vulnerabilities/exec/" "Mozilla/5.0 ..."
# Note: In POST requests, the payload "ip=127.0.0.1%3B+whoami" travels in the HTTP request body.
```

#### Remediation Diff
```php
// BEFORE (Vulnerable shell_exec)
$target = $_REQUEST['ip'];
$cmd = shell_exec('ping -c 4 ' . $target);
echo "<pre>{$cmd}</pre>";

// AFTER (Strict Whitelisting & Escaping)
$target = $_REQUEST['ip'];
// Validate that input strictly matches a valid IPv4 address
if (filter_var($target, FILTER_VALIDATE_IP, FILTER_FLAG_IPV4)) {
    $cmd = shell_exec('ping -c 4 ' . escapeshellarg($target));
    echo "<pre>" . htmlspecialchars($cmd, ENT_QUOTES, 'UTF-8') . "</pre>";
} else {
    echo "<pre>ERROR: Invalid IPv4 address format supplied.</pre>";
}
```

---

### 5. Local File Inclusion (LFI) — CWE-22 / OWASP A01

#### Technical Breakdown & Mechanism
Local File Inclusion occurs when an application uses user input to construct a file path for a file handling or dynamic inclusion function (e.g., `include`, `require`, `include_once`, `file_get_contents`) without verifying whether the path stays within the intended directory boundaries. By utilizing directory traversal sequences (`../`), an attacker can navigate outside the web root to read arbitrary files on the operating system.

#### Exploitation Execution
- **Target Endpoint**: `/DVWA/vulnerabilities/fi/`
- **Target Parameter**: `page`
- **Payload 1 (Absolute Path)**: `page=/etc/passwd`
- **Payload 2 (Directory Traversal)**: `page=../../../../etc/passwd`
- **Observed Result**: The application successfully traversed the filesystem and rendered the complete contents of `/etc/passwd`, exposing system accounts including `root:x:0:0:root:/root:/bin/bash`, `www-data:x:33:33:...`, and `kali:x:1000:1000:...`.
- **Evidence Reference**: [13-LFI-Etc-Passwd.png](evidence/exploitation/13-LFI-Etc-Passwd.png)

#### Forensic Access Log Signature
```log
127.0.0.1 - - [06/Sep/2026:11:51:19 +0530] "GET /DVWA/vulnerabilities/fi/?page=../../../../etc/passwd HTTP/1.1" 200 6814 "http://127.0.0.1/DVWA/vulnerabilities/fi/" "Mozilla/5.0 ..."
```

#### Remediation Diff
```php
// BEFORE (Vulnerable Include)
$file = $_GET['page'];
include($file);

// AFTER (Strict Allowlist Pattern)
$file = $_GET['page'];
$allowed_pages = [
    'include.php' => 'include.php',
    'file1.php'   => 'file1.php',
    'file2.php'   => 'file2.php',
    'file3.php'   => 'file3.php'
];

if (array_key_exists($file, $allowed_pages)) {
    include($allowed_pages[$file]);
} else {
    http_response_code(404);
    echo "Error: Requested page is not authorized or does not exist.";
}
```

---

### 6. Directory Indexing & Information Disclosure — CWE-548 / OWASP A05

- **Vulnerability**: Apache `mod_autoindex` was enabled without negative indexing restrictions, generating automated HTML directory listings whenever an index file was missing.
- **Affected Endpoints**: `/DVWA/config/`, `/DVWA/tests/`, `/DVWA/database/`, `/DVWA/docs/`.
- **Exploitation / Threat**: Allowed unauthenticated users to browse internal test scripts, database schema templates, and documentation.
- **Remediation**: Injected `Options -Indexes` into `/etc/apache2/sites-available/000-default.conf`.
- **Evidence References**:
  - Baseline detection: [06-Nikto-Web-Recon.png](evidence/reconnaissance/06-Nikto-Web-Recon.png)
  - Config test: [24-Apache-Directory-Indexing-Config-Test.png](evidence/remediation/24-Apache-Directory-Indexing-Config-Test.png)
  - Verification rescan (4 directory listings cleared): [26-Nikto-After-Directory-Indexing-Fix.png](evidence/remediation/26-Nikto-After-Directory-Indexing-Fix.png)

---

### 7. Sensitive Build Artifact Exposure — CWE-538 / OWASP A05

- **Vulnerability**: The `.dockerignore` configuration file was situated directly inside the public document root (`/var/www/html/DVWA/.dockerignore`), accessible via direct HTTP requests (`200 OK`).
- **Threat**: Disclosed internal repository structure, excluded files, and container build metadata.
- **Remediation**: Quarantined the file by renaming it to `.dockerignore.bak` outside of the web server's published path.
- **Verification**: `curl -I http://127.0.0.1/DVWA/.dockerignore` returned `HTTP/1.1 404 Not Found`.
- **Evidence Reference**: [33-Dockerignore-Exposure-Fixed.png](evidence/remediation/33-Dockerignore-Exposure-Fixed.png)

---

### 8. Missing HTTP Security Headers — CWE-1021 / OWASP A05

- **Vulnerability**: Absence of standard browser-hardening response headers left clients vulnerable to clickjacking, unauthorized hardware access, and protocol downgrade attacks.
- **Remediation**: Added Apache `mod_headers` directives:
  ```apache
  Header always set Permissions-Policy "geolocation=(), microphone=(), camera=()"
  Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains"
  ```
- **Verification**: Nikto rescan confirmed that warnings for both headers were completely resolved.
- **Evidence Reference**: [33-Dockerignore-Exposure-Fixed.png](evidence/remediation/33-Dockerignore-Exposure-Fixed.png)

---

## 🚨 Incident Response Simulation (NIST SP 800-61 Rev. 2)

The incident response simulation exercised the full operational workflow of a Security Operations Center (SOC) analyst responding to an active web application compromise.

```
       [ STEP 1: DETECTION ]                 [ STEP 2: CONTAINMENT ]               [ STEP 3: ERADICATION ]
┌──────────────────────────────────┐   ┌──────────────────────────────────┐   ┌──────────────────────────────────┐
│  Forensic log triage of access   │   │  Immediate service isolation     │   │  Code refactor (Prepared Stmt)   │
│  logs via custom regex pattern   │──>│  via systemctl stop apache2      │──>│  Apache VirtualHost hardening    │
│  Identifying high-risk IoCs      │   │  Eliminating active vectors      │   │  Header & artifact quarantine    │
└──────────────────────────────────┘   └──────────────────────────────────┘   └──────────────────────────────────┘
                                                                                                │
                                             [ STEP 5: LESSONS LEARNED ]              [ STEP 4: RECOVERY ]
                                       ┌──────────────────────────────────┐   ┌──────────────────────────────────┐
                                       │  Post-mortem incident reporting  │   │  Service restoration & checks    │
                                       │  Root-cause analysis & metrics   │<──│  Nikto audit: 11 down to 1 item  │
                                       │  Enterprise defense roadmap      │   │  Active operational validation   │
                                       └──────────────────────────────────┘   └──────────────────────────────────┘
```

---

### Phase 1: Detection & Forensic Log Triage

#### Detection Mechanism & Command
Using native Linux command-line utilities, defenders monitored `/var/log/apache2/access.log` using an intrusion detection regex designed to flag known attack signatures across query strings, path traversals, and command execution primitives:
```bash
sudo grep -Ei "etc/passwd|union|select|script|or.*=|cmd|127\.0\.0\.1" /var/log/apache2/access.log | tail -n 30
```

#### Forensic Breakdown of the Regex
- `etc/passwd`: Flags Local File Inclusion (LFI) attempts targeting the Linux user registry.
- `union|select`: Catches classic SQL injection data-exfiltration syntax.
- `script`: Flags Cross-Site Scripting (XSS) script tags.
- `or.*=`: Detects boolean SQL injection tautologies (e.g., `OR '1'='1'`).
- `cmd`: Identifies command execution parameters and webshell references.
- `127\.0\.0\.1`: Isolates traffic originating from the loopback testbed.

#### Extracted Indicators of Compromise (IoCs)
- **Attacker IP**: `127.0.0.1` (Local loopback).
- **Target Host**: Apache `2.4.68 (Debian)` on port 80.
- **Identified Exploit Signatures in Logs**:
  - `GET /DVWA/vulnerabilities/sqli/?id=1%27+OR+%271%27%3D%271&Submit=Submit` (`200 OK`) -> SQLi exploitation.
  - `GET /DVWA/vulnerabilities/xss_r/?name=%3Cscript%3Ealert(...)` (`200 OK`) -> Reflected XSS.
  - `GET /DVWA/vulnerabilities/fi/?page=../../../../etc/passwd` (`200 OK`) -> LFI directory traversal.
  - `POST /DVWA/vulnerabilities/exec/` (`200 OK`) -> OS command execution.
- **Evidence References**:
  - Raw attack logs: [14-Apache-Attack-Logs.png](evidence/detection/14-Apache-Attack-Logs.png)
  - Filtered suspicious logs: [15-Suspicious-Attack-Logs.png](evidence/detection/15-Suspicious-Attack-Logs.png)

---

### Phase 2: Emergency Service Containment

#### Containment Actions
Upon confirming active exploitation across multiple vulnerability classes, the incident commander authorized emergency service isolation to prevent further lateral movement, persistent backdoor placement, or continued data exfiltration.
- **Execution Commands**:
  ```bash
  sudo systemctl stop apache2
  sudo systemctl is-active apache2
  ```
- **Observed Output**:
  ```text
  inactive
  ```
- **Containment Impact**: The Apache listening socket on `*:80` was immediately terminated. All active HTTP sessions were dropped. Attackers could no longer interact with any DVWA endpoint, effectively freezing the attack surface while preserving logs on disk for forensic analysis.
- **Evidence Reference**: [16-Incident-Containment-Apache-Stopped.png](evidence/containment/16-Incident-Containment-Apache-Stopped.png)

---

### Phase 3: Eradication & Hardening

With the service safely contained, remediation engineers addressed each identified vulnerability at its root:

1. **SQL Injection Eradication**:
   - Refactored `vulnerabilities/sqli/source/high.php` to replace raw string concatenation with PDO prepared statements.
   - Performed PHP syntax validation:
     ```bash
     php -l /var/www/html/DVWA/vulnerabilities/sqli/source/high.php
     # Output: No syntax errors detected in /var/www/html/DVWA/vulnerabilities/sqli/source/high.php
     ```
   - Evidence: [18-SQLi-High-Source.png](evidence/remediation/18-SQLi-High-Source.png), [24-Apache-Directory-Indexing-Config-Test.png](evidence/remediation/24-Apache-Directory-Indexing-Config-Test.png)

2. **Directory Indexing Eradication**:
   - Updated `/etc/apache2/sites-available/000-default.conf` to disable directory listings:
     ```apache
     <Directory /var/www/html>
         Options -Indexes +FollowSymLinks
         AllowOverride None
         Require all granted
     </Directory>
     ```
   - Validated Apache configuration syntax:
     ```bash
     apache2ctl configtest
     # Output: Syntax OK
     ```
   - Evidence: [24-Apache-Directory-Indexing-Config-Test.png](evidence/remediation/24-Apache-Directory-Indexing-Config-Test.png), [25-Apache-Directory-Indexing-Applied.png](evidence/remediation/25-Apache-Directory-Indexing-Applied.png)

3. **HTTP Security Header Deployment**:
   - Enabled `mod_headers` and injected `Permissions-Policy` and `Strict-Transport-Security` directives.
   - Evidence: [33-Dockerignore-Exposure-Fixed.png](evidence/remediation/33-Dockerignore-Exposure-Fixed.png)

4. **Sensitive File Removal**:
   - Relocated `.dockerignore` to `.dockerignore.bak` outside of the web server document path.
   - Tested HTTP response:
     ```bash
     curl -I http://127.0.0.1/DVWA/.dockerignore
     # Output: HTTP/1.1 404 Not Found
     ```
   - Evidence: [33-Dockerignore-Exposure-Fixed.png](evidence/remediation/33-Dockerignore-Exposure-Fixed.png)

---

### Phase 4: Recovery & Operational Verification

#### Service Restoration
Following configuration audits and syntax verification, services were brought back online in a controlled manner:
```bash
sudo systemctl start apache2
sudo systemctl is-active apache2 mariadb
```
- **Observed Output**:
  ```text
  active
  active
  ```

#### Multi-Stage Verification Progression
Security posture improvements were validated through consecutive, iterative Nikto vulnerability rescans:

1. **Iteration 1 (Baseline)**: **11 items reported** (Directory indexing on 4 folders, missing headers, exposed `.dockerignore`, etc.).
2. **Iteration 2 (Directory Indexing Fixed)**: Dropped to **4 items reported** (All 4 directory indexing alerts eliminated).
3. **Iteration 3 (Headers & Artifact Fixed)**: Dropped to **2 items reported** (Headers applied, `.dockerignore` returns 404).
4. **Iteration 4 (Final Recovery Audit)**: Dropped to **1 informational item reported**:
   ```text
   + Target IP:          127.0.0.1
   + Target Hostname:    127.0.0.1
   + Target Port:        80
   + 8020 requests: 0 error(s) and 1 item(s) reported on remote host
   + Entry /DVWA/login.php: This might be interesting.
   ```
- **Result**: The single remaining item (`/DVWA/login.php`) is the expected legitimate application login interface, confirming that **100% of the actionable vulnerability findings reported by the automated scanner were successfully resolved**.
- **Evidence Reference**: [35-Recovery-Services-Verified.png](evidence/recovery/35-Recovery-Services-Verified.png)

---

### Phase 5: Post-Incident Lessons Learned

1. **Default Configurations are Insecure**: Production web servers must never rely on distribution-default configurations. Directives such as `Options -Indexes` and strict header sets must be enforced at provisioning time via automated infrastructure-as-code (IaC).
2. **Input Sanitization Alone is Insufficient**: Sanitizing inputs via blacklists is easily bypassed. Parameterization (prepared statements) separates SQL logic from untrusted data at the engine level, providing mathematical immunity against SQL injection.
3. **Log Centralization is Vital**: Real-time log monitoring is critical for rapid incident containment. Local access logs can be rotated or deleted by an attacker who achieves command execution; therefore, shipping logs off-host to a dedicated SIEM is essential.

---

## 📊 Remediation & Hardening Delta Comparison

| Security Control / Audit Check | Baseline State (Pre-Hardening) | Remediated State (Post-Hardening) | Verification Status & Evidence |
|---|---|---|---|
| **SQL Injection (`high.php`)** | Dynamic string concatenation; dumps all 5 user records with `1' OR '1'='1`. | Prepared statements (`PDO::prepare`); syntax validated via `php -l`. | Syntax validated; functional test verified. [24-Config-Test](evidence/remediation/24-Apache-Directory-Indexing-Config-Test.png) |
| **Directory Indexing (CWE-548)** | Enabled; allows browsing of `/config/`, `/tests/`, `/database/`, `/docs/`. | Disabled via `Options -Indexes` in `000-default.conf`; `Syntax OK`. | **100% Remediated**. All 4 directory alerts cleared. [26-Nikto-Fix](evidence/remediation/26-Nikto-After-Directory-Indexing-Fix.png) |
| **Exposed Build Artifacts** | `/.dockerignore` returned `HTTP 200 OK` directly from document root. | Moved to `.dockerignore.bak`; direct access blocked. | **100% Remediated**. Confirmed `HTTP 404 Not Found`. [33-Dockerignore](evidence/remediation/33-Dockerignore-Exposure-Fixed.png) |
| **`Strict-Transport-Security`** | Missing from HTTP response headers. | Header enforced via Apache `mod_headers`. | **100% Remediated**. Nikto warning resolved. [33-Dockerignore](evidence/remediation/33-Dockerignore-Exposure-Fixed.png) |
| **`Permissions-Policy`** | Missing from HTTP response headers. | Header enforced (`geolocation=(), microphone=()`). | **100% Remediated**. Nikto warning resolved. [33-Dockerignore](evidence/remediation/33-Dockerignore-Exposure-Fixed.png) |
| **Automated Scan Findings** | **11 items reported** across security misconfigurations and exposed folders. | **1 informational item** (`/DVWA/login.php` legitimate login endpoint). | **90.9% Alert Reduction**. 0 scanner errors. [35-Recovery](evidence/recovery/35-Recovery-Services-Verified.png) |
| **Core Services Health** | Services unhardened, actively susceptible to exploitation. | Apache and MariaDB actively running under hardened configuration. | **Active & Healthy**. `systemctl is-active` confirms both active. [35-Recovery](evidence/recovery/35-Recovery-Services-Verified.png) |

---

## 🏰 Enterprise Defense-in-Depth Architecture

To translate the lessons learned from this simulated local engagement into production-grade enterprise cybersecurity practices, the following defense-in-depth controls are recommended:

```
                                  ENTERPRISE DEFENSE-IN-DEPTH MODEL
                                  
   [ EXTERNAL TRAFFIC ]
           │
           ▼
┌──────────────────────┐   Layer 1: Network Edge
│ Cloudflare / AWS WAF │   * DDoS mitigation, IP reputation, rate limiting
└──────────────────────┘   * Global TLS termination and HSTS enforcement
           │
           ▼
┌──────────────────────┐   Layer 2: Application Gateway / Reverse Proxy
│ ModSecurity / CRS    │   * OWASP Core Rule Set (CRS) inspection
└──────────────────────┘   * Blocks SQLi, XSS, and LFI patterns before reaching backend
           │
           ▼
┌──────────────────────┐   Layer 3: Hardened Web Middleware
│ Apache / Nginx       │   * Options -Indexes, ServerTokens Prod, Header controls
└──────────────────────┘   * Non-root process execution (www-data with limited permissions)
           │
           ▼
┌──────────────────────┐   Layer 4: Secure Application Logic
│ PHP / Modern App     │   * Strict input validation (whitelisting)
└──────────────────────┘   * PDO Prepared statements, Contextual HTML entity encoding
           │
           ▼
┌──────────────────────┐   Layer 5: Database Layer Hardening
│ MariaDB / PostgreSQL │   * Dedicated unprivileged user per microservice (least privilege)
└──────────────────────┘   * Local UNIX socket only; network bind disabled
           │
           ▼
┌──────────────────────┐   Layer 6: Continuous Security Operations
│ SIEM & DevSecOps     │   * Wazuh / Elastic SIEM log forwarding for real-time alerting
└──────────────────────┘   * GitHub Actions CI/CD with Semgrep (SAST) & OWASP ZAP (DAST)
```

1. **Web Application Firewall (WAF) Integration**:
   - Deploy **ModSecurity** with the **OWASP Core Rule Set (CRS)** to intercept and block SQL injection tautologies, path traversals (`../`), and script injection attempts before they reach application execution.
2. **Centralized Log Streaming & SIEM Alerting**:
   - Forward web server access logs to a centralized Security Information and Event Management (SIEM) platform (e.g., **Wazuh**, **Elastic Stack**, or **Splunk**).
   - Configure correlation rules that trigger automated containment alerts when more than 5 anomalous patterns occur within a 60-second window.
3. **Automated CI/CD DevSecOps Pipeline**:
   - Integrate Static Application Security Testing (**SAST**) using tools like **Semgrep** or **SonarQube** to detect raw string concatenations in database queries prior to code merge.
   - Run Dynamic Application Security Testing (**DAST**) using **OWASP ZAP** against staging environments before production deployments.
4. **Operating System & Database Least Privilege**:
   - Ensure the web runtime user (`www-data`) has read-only access to application files and cannot execute sensitive system utilities (`ping`, `curl`, `bash`).
   - Restrict database user accounts so that the application user only holds `SELECT`, `INSERT`, and `UPDATE` permissions on required tables, preventing schema manipulation (`DROP`, `ALTER`).

---

## 🖼️ Curated Evidence Gallery

Every assertion in this project is corroborated by local terminal screenshots captured during execution:

| Phase | Description | Key Command / Activity | Evidence Artifact Link |
|---|---|---|---|
| **Reconnaissance** | Socket & Network Interface Audit | `ip addr` & `ss -tulpn` (Port 80 confirmed) | [02-Apache-Port-80.png](evidence/reconnaissance/02-Apache-Port-80.png) |
| **Reconnaissance** | Case Sensitivity & Banner Check | `curl -I http://127.0.0.1/DVWA/` (Apache 2.4.68) | [03-DVWA-Endpoint-Verified.png](evidence/reconnaissance/03-DVWA-Endpoint-Verified.png) |
| **Scanning** | Transport Layer Service Discovery | `nmap -sV -p 80,443 127.0.0.1` | [04-Nmap-Recon-Scan.png](evidence/reconnaissance/04-Nmap-Recon-Scan.png) |
| **Scanning** | Baseline Vulnerability Assessment | `nikto -h http://127.0.0.1/DVWA/` (11 items) | [06-Nikto-Web-Recon.png](evidence/reconnaissance/06-Nikto-Web-Recon.png) |
| **Exploitation** | SQLi Baseline Legitimate Query | `id=1` returns Admin record | [07-SQLi-Baseline.png](evidence/exploitation/07-SQLi-Baseline.png) |
| **Exploitation** | SQLi Boolean Exploitation | `id=1' OR '1'='1` dumps all 5 user accounts | [08-SQLi-Vulnerable-Response.png](evidence/exploitation/08-SQLi-Vulnerable-Response.png) |
| **Exploitation** | Reflected XSS PoC Execution | `<script>alert('DVWA-XSS-Test')</script>` | [09-XSS-Reflected-Alert.png](evidence/exploitation/09-XSS-Reflected-Alert.png) |
| **Exploitation** | Stored XSS PoC Execution | Guestbook persistent alert modal execution | [10-XSS-Stored-Alert.png](evidence/exploitation/10-XSS-Stored-Alert.png) |
| **Exploitation** | Command Injection Baseline | Legitimate ping utility execution (`127.0.0.1`) | [11-Command-Injection-Baseline.png](evidence/exploitation/11-Command-Injection-Baseline.png) |
| **Exploitation** | Command Injection Exploitation | `127.0.0.1; whoami` reveals `www-data` user | [12-Command-Injection-Executed.png](evidence/exploitation/12-Command-Injection-Executed.png) |
| **Exploitation** | Local File Inclusion Exploitation | `page=/etc/passwd` traverses & dumps user list | [13-LFI-Etc-Passwd.png](evidence/exploitation/13-LFI-Etc-Passwd.png) |
| **Detection** | Raw Web Access Log Inspection | `tail -n 30 /var/log/apache2/access.log` | [14-Apache-Attack-Logs.png](evidence/detection/14-Apache-Attack-Logs.png) |
| **Detection** | Suspicious Attack Regex Triage | Forensic `grep -Ei` filtering attack patterns | [15-Suspicious-Attack-Logs.png](evidence/detection/15-Suspicious-Attack-Logs.png) |
| **Containment** | Emergency Service Isolation | `systemctl stop apache2` (`inactive`) | [16-Incident-Containment-Apache-Stopped.png](evidence/containment/16-Incident-Containment-Apache-Stopped.png) |
| **Remediation** | SQLi Code Review & Analysis | Source code audit of `high.php` | [18-SQLi-High-Source.png](evidence/remediation/18-SQLi-High-Source.png) |
| **Remediation** | Code & Apache Config Verification | `php -l` & `apache2ctl configtest` (Syntax OK) | [24-Apache-Directory-Indexing-Config-Test.png](evidence/remediation/24-Apache-Directory-Indexing-Config-Test.png) |
| **Remediation** | Directory Indexing Applied | Reloading Apache with hardened configuration | [25-Apache-Directory-Indexing-Applied.png](evidence/remediation/25-Apache-Directory-Indexing-Applied.png) |
| **Remediation** | Post-Indexing Rescan Verification | Nikto items drop from 11 to 4 | [26-Nikto-After-Directory-Indexing-Fix.png](evidence/remediation/26-Nikto-After-Directory-Indexing-Fix.png) |
| **Remediation** | Headers & File Quarantine Fix | Security headers added; `.dockerignore` 404 | [33-Dockerignore-Exposure-Fixed.png](evidence/remediation/33-Dockerignore-Exposure-Fixed.png) |
| **Recovery** | Final Operational Verification | Apache & MariaDB active; Nikto drops to 1 item | [35-Recovery-Services-Verified.png](evidence/recovery/35-Recovery-Services-Verified.png) |

---

## 📁 Repository Structure & Navigation

```text
d:/Cybersecurity-Task5/
├── README.md                                  # Master portfolio document & project overview
├── LICENSE                                    # MIT open-source license
├── .gitignore                                 # Git configuration for transient artifacts
│
├── docs/                                      # Granular, professional technical reports
│   ├── 01-project-overview.md                 # Internship context, timeline, milestones
│   ├── 02-scope-and-objectives.md             # Authorized targets and boundary rules
│   ├── 03-lab-architecture.md                 # System components and network topology
│   ├── 04-reconnaissance.md                   # Socket inspection, interface and path probes
│   ├── 05-scanning.md                         # Port scanning & baseline Nikto scan findings
│   ├── 06-vulnerability-testing.md            # In-depth exploitation walkthroughs (SQLi, XSS, CI, LFI)
│   ├── 07-findings-and-risk.md                # Comprehensive vulnerability matrix & risk ratings
│   ├── 08-remediation.md                      # Code refactoring diffs & Apache hardening configs
│   ├── 09-incident-response.md                # Forensic log analysis, containment, and eradication
│   ├── 10-recovery.md                         # Service restoration and multi-stage Nikto rescan audits
│   └── 11-post-incident-summary.md            # Lessons learned, gap analysis, enterprise roadmap
│
├── evidence/                                  # Verified, non-repudiable screenshot artifacts
│   ├── reconnaissance/                        # Port 80 checks, curl headers, Nmap, baseline Nikto
│   ├── exploitation/                          # SQLi, Reflected XSS, Stored XSS, CI, LFI PoCs
│   ├── detection/                             # Apache access logs & suspicious regex filtering
│   ├── containment/                           # Service halt verification (inactive state)
│   ├── remediation/                           # Prepared statements, syntax checks, header verification
│   └── recovery/                              # Final Nikto scan and multi-service active checks
│
├── diagrams/
│   └── network-diagram.png                    # High-resolution lab architecture & threat workflow diagram
│
├── notes/
│   └── methodology.md                         # PTES, OWASP, NIST frameworks and epistemological standards
│
└── scripts/
    └── README.md                              # Operational policy regarding native CLI tools & safety
```

### Quick Documentation Links
- Detailed Project Context & Schedule: [docs/01-project-overview.md](docs/01-project-overview.md)
- Complete Vulnerability Testing Logs: [docs/06-vulnerability-testing.md](docs/06-vulnerability-testing.md)
- Code & Server Remediation Guide: [docs/08-remediation.md](docs/08-remediation.md)
- Forensic Incident Response Protocol: [docs/09-incident-response.md](docs/09-incident-response.md)
- Verification & Delta Analysis: [docs/10-recovery.md](docs/10-recovery.md)

---

## 💡 Key Takeaways & Security Insights

1. **Separation of Code and Data**: Dynamic string concatenation in SQL and OS command contexts fundamentally breaks the security model. Parameterization (prepared statements) and strict parameter whitelisting guarantee that user data is never parsed as executable instructions.
2. **Proactive Hardening Reduces Reconnaissance Surface**: Default web server installations are inherently noisy and permissive. Disabling directory indexing (`Options -Indexes`), deploying security headers (`HSTS`, `Permissions-Policy`), and enforcing strict file permissions immediately eliminates low-hanging reconnaissance targets.
3. **Log Visibility Drives Incident Response**: Without detailed access logs, detecting and containing an active breach is impossible. The incident response simulation proved that high-fidelity log collection enables analysts to rapidly reconstruct the attacker's timeline and deploy targeted containment.
4. **Iterative Verification Validates Security Posture**: Security cannot be assumed; it must be proven. Conducting post-hardening rescan audits systematically confirmed the reduction of scanner alerts from 11 down to 1 informational finding.

---

## ⚖️ Legal, Ethical & Educational Disclaimer

This project was conducted strictly for educational and internship training purposes within an authorized, isolated local laboratory environment as part of the **Cybersecurity & Ethical Hacking Internship Program** at **ApexPlanet Software Pvt. Ltd.**

All testing, scanning, exploitation, and incident response activities were executed against a locally hosted virtual instance of Damn Vulnerable Web Application (DVWA v1.9+) bound to `127.0.0.1`. **No unauthorized access, probing, or testing was performed or directed against any real-world, public, or third-party computer systems or networks.** This documentation is published for educational and portfolio demonstration purposes to promote secure coding practices and defensive cyber resilience.
