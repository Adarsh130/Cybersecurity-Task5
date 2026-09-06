# 02 — Scope and Objectives

## 1. Project Authorization & Legal Boundary

This project was conducted under explicit authorization as an educational internship capstone project. 

> [!IMPORTANT]
> **Authorized Environment Only**: All testing, reconnaissance, controlled exploitation, log monitoring, and incident containment activities were conducted solely within an isolated, local virtual lab on Kali Linux targeting `http://127.0.0.1/DVWA/`. No testing was directed against any public, production, third-party, or unauthorized network assets.

---

## 2. In-Scope vs. Out-of-Scope Assets

### In-Scope Assets
- **Target URL**: `http://127.0.0.1/DVWA/`
- **Host**: Kali Linux local virtual machine (`127.0.0.1`, loopback interface `lo`)
- **Web Middleware**: Apache HTTP Server 2.4.68 (Debian) on TCP Port 80
- **Database Service**: MariaDB local database server instance
- **Application Modules**:
  - DVWA SQL Injection (`/vulnerabilities/sqli/`)
  - DVWA Reflected Cross-Site Scripting (`/vulnerabilities/xss_r/`)
  - DVWA Stored Cross-Site Scripting (`/vulnerabilities/xss_s/`)
  - DVWA Command Injection (`/vulnerabilities/exec/`)
  - DVWA File Inclusion (`/vulnerabilities/fi/`)
- **Server Configuration Files**:
  - `/etc/apache2/sites-available/000-default.conf`
  - `/var/www/html/DVWA/.dockerignore`
  - `/var/www/html/DVWA/vulnerabilities/sqli/source/high.php`
- **Log Files**:
  - `/var/log/apache2/access.log`
  - `/var/log/apache2/error.log`

### Out-of-Scope Assets
- Any external IP address or internet-facing endpoint.
- Denial of Service (DoS / DDoS) stress testing.
- Physical attacks, social engineering, or brute forcing against non-lab infrastructure.
- Modification of operating system accounts outside the authorized web root and service configuration files.

---

## 3. Project Objectives

1. **Reconnaissance & Asset Discovery**:
   - Verify listening sockets, open ports, and running service daemon states.
   - Catalog web server banners, HTTP headers, directory structures, and configuration exposures.
2. **Controlled Vulnerability Validation**:
   - Demonstrate the presence of critical OWASP Top 10 vulnerabilities using safe, non-destructive payloads.
   - Document raw HTTP inputs, URL query parameters, server responses, and DOM execution evidence.
3. **Incident Detection & Log Analysis**:
   - Monitor and parse Apache access logs to identify active reconnaissance scans and exploit injection patterns.
   - Formulate specific regex search filters to isolate malicious indicators of compromise (IoCs).
4. **Simulated Containment**:
   - Execute an immediate incident response containment action by halting the web daemon to eliminate exposure.
5. **Eradication & System Hardening**:
   - Refactor vulnerable PHP database query logic to use parameterized prepared statements.
   - Disable web directory indexing to mitigate information disclosure (CWE-548).
   - Inject mandatory security response headers (`Permissions-Policy`, `Strict-Transport-Security`).
   - Remove sensitive configuration files from the public document root.
6. **Recovery & Rescan Verification**:
   - Conduct syntax validation and service restoration audits.
   - Re-execute automated vulnerability scans (Nikto) and HTTP status queries (`curl -I`) to confirm remediation.
