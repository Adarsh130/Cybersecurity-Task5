# 07 — Findings & Qualitative Risk Assessment

## 1. Vulnerability Findings Matrix

The following matrix summarizes all confirmed security findings identified during controlled testing and automated scanning. 

> [!NOTE]
> In accordance with project accuracy guidelines, severity ratings are based on qualitative risk assessments derived strictly from observed behavior rather than fabricated CVSS calculations or unverified CVE identifiers.

| # | Finding | Vulnerability Category | Evidence Artifact | Qualitative Impact Assessment | Remediation Strategy | Verification Status |
|---|---|---|---|---|---|---|
| **F-01** | Command Injection via Form Input | Injection (OWASP A03:2021) | [12-Command-Injection-Executed.png](../evidence/exploitation/12-Command-Injection-Executed.png) | **High**: Arbitrary OS command execution under `www-data` user context. | Avoid shell execution wrappers (`shell_exec`); implement strict input regex validation and whitelisting. | Controlled PoC verified; remediation queued. |
| **F-02** | SQL Injection via Dynamic Query Construction | Injection (OWASP A03:2021) | [08-SQLi-Vulnerable-Response.png](../evidence/exploitation/08-SQLi-Vulnerable-Response.png) | **High**: Full bypass of SQL query logic allowing database table extraction. | Enforce parameterized queries using PDO/MySQLi prepared statements; apply HTML escaping. | Prepared statements implemented; syntax verified; functional baseline checked. |
| **F-03** | Local File Inclusion (LFI) via Path Traversal | Broken Access Control (OWASP A01:2021) | [13-LFI-Etc-Passwd.png](../evidence/exploitation/13-LFI-Etc-Passwd.png) | **High**: Unauthorized disclosure of system files (`/etc/passwd`). | Whitelist allowed filenames; disable direct user path passing to `include()`/`require()`. | Controlled PoC verified; remediation queued. |
| **F-04** | Stored Cross-Site Scripting (Stored XSS) | Injection (OWASP A03:2021) | [10-XSS-Stored-Alert.png](../evidence/exploitation/10-XSS-Stored-Alert.png) | **Medium**: Persistent script execution in client browsers viewing guestbook entries. | Sanitize and contextually encode all user submissions prior to database persistence and DOM rendering. | Controlled PoC verified. |
| **F-05** | Reflected Cross-Site Scripting (Reflected XSS) | Injection (OWASP A03:2021) | [09-XSS-Reflected-Alert.png](../evidence/exploitation/09-XSS-Reflected-Alert.png) | **Medium**: Immediate script execution via craftable malicious URLs. | Implement contextual HTML output encoding (`htmlspecialchars()`) on reflected parameters. | Controlled PoC verified. |
| **F-06** | Apache Web Directory Indexing (CWE-548) | Security Misconfiguration (OWASP A05:2021) | [06-Nikto-Web-Recon.png](../evidence/reconnaissance/06-Nikto-Web-Recon.png) | **Low to Medium**: Exposure of directory contents (`/config/`, `/tests/`, `/database/`, `/docs/`). | Disable directory indexing globally in Apache via `Options -Indexes`. | **Fully Remediated & Verified** (Nikto confirms findings cleared). |
| **F-07** | Sensitive Deployment File Exposure (`.dockerignore`) | Security Misconfiguration (OWASP A05:2021) | [06-Nikto-Web-Recon.png](../evidence/reconnaissance/06-Nikto-Web-Recon.png) | **Low**: Disclosure of project structure and repository file exclusion rules. | Relocate configuration files outside public web document root. | **Fully Remediated & Verified** (HTTP 404 Not Found confirmed). |
| **F-08** | Missing HTTP Security Headers (HSTS, Permissions-Policy) | Security Misconfiguration (OWASP A05:2021) | [06-Nikto-Web-Recon.png](../evidence/reconnaissance/06-Nikto-Web-Recon.png) | **Low**: Absence of defense-in-depth transport and browser API restrictions. | Define `Permissions-Policy` and `Strict-Transport-Security` headers in Apache configuration. | **Fully Remediated & Verified** (Nikto confirms headers present). |
| **INFO** | Admin Login Page Detected (`/DVWA/login.php`) | Informational Endpoint Detection | [06-Nikto-Web-Recon.png](../evidence/reconnaissance/06-Nikto-Web-Recon.png) | **Informational**: Expected application authentication portal. | No remediation required; ensure rate limiting and brute-force protection in production. | Informational only. |

---

## 2. Root Cause Analysis Summary

1. **Unsanitized Input Processing**:
   - The application directly concatenated user parameters into shell commands (`shell_exec`), SQL queries (`mysqli_query`), and file system calls (`include`), violating input validation boundaries.
2. **Missing Output Encoding**:
   - Form inputs were echoed directly into web page responses without contextual encoding (HTML entity encoding), enabling browser-side script execution.
3. **Default Web Server Configuration**:
   - Apache's default virtual host configuration permitted directory browsing where `index.php` was absent, exposing internal directories.
4. **Build Artifact Leftovers**:
   - Development repository artifacts (`.dockerignore`) were placed directly in the web server document root during deployment.
