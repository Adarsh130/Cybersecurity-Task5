# 🎥 Task 5 Video Presentation & Demonstration Script

**Project Title**: Web Application Penetration Testing & Incident Response Simulation on DVWA  
**Program**: ApexPlanet Cybersecurity & Ethical Hacking Internship Program (Task 5: Days 49–60)  
**Author**: Security Intern (Adarsh)  
**Target**: Damn Vulnerable Web Application (DVWA v1.9+) on Kali Linux (`http://127.0.0.1/DVWA/`)  
**Duration**: Approximately 10 Minutes  

---

## ⏱️ Timeline & Presentation Structure

| Timestamp | Phase | Visual / On-Screen Content | Talking Points & Script Narration |
|---|---|---|---|
| **00:00 - 01:15** | **Introduction & Scope** | Lab architecture diagram (`diagrams/network-diagram.png`) and `README.md` | Introduction to Task 5 capstone; authorized boundaries on local loopback interface (`127.0.0.1`); Dual framework: OWASP WSTG + NIST SP 800-61 Rev. 2. |
| **01:15 - 02:30** | **Reconnaissance & Scanning** | `02-Apache-Port-80.png`, `04-Nmap-Recon-Scan.png`, `06-Nikto-Web-Recon.png` | Demonstrating socket audit (`ss -tulpn`), Nmap version detection (`Apache 2.4.68`), and baseline Nikto scan reporting 11 initial findings. |
| **02:30 - 04:00** | **Offensive Exploitation (SQLi & XSS)** | `08-SQLi-Vulnerable-Response.png`, `09-XSS-Reflected-Alert.png`, `10-XSS-Stored-Alert.png` | Demonstrating SQL injection boolean bypass (`1' OR '1'='1`) dumping user table; Reflected and Stored XSS triggering JavaScript alert popups. |
| **04:00 - 05:15** | **Command Injection & LFI** | `12-Command-Injection-Executed.png`, `13-LFI-Etc-Passwd.png` | Explaining command separator (`127.0.0.1; whoami`) returning `www-data`; Local File Inclusion (`../../../../etc/passwd`) dumping Linux user accounts. |
| **05:15 - 06:45** | **Incident Detection (Log Forensics)** | `14-Apache-Attack-Logs.png`, `15-Suspicious-Attack-Logs.png` | Dissecting `/var/log/apache2/access.log` using forensic regex triage; correlating attacker IP, status codes (200 OK), and exploit signatures. |
| **06:45 - 07:45** | **Emergency Containment** | `16-Incident-Containment-Apache-Stopped.png` | Immediate operational isolation via `systemctl stop apache2`; terminating socket listener on port 80 to neutralize active threats. |
| **07:45 - 08:45** | **Eradication & Hardening** | `18-SQLi-High-Source.png`, `24-Apache-Directory-Indexing-Config-Test.png`, `25-Apache-Directory-Indexing-Applied.png` | Implementing PDO prepared statements; disabling directory browsing (`Options -Indexes`); deploying HSTS and Permissions-Policy headers. |
| **08:45 - 09:30** | **Recovery & Delta Verification** | `26-Nikto-After-Directory-Indexing-Fix.png`, `33-Dockerignore-Exposure-Fixed.png`, `35-Recovery-Services-Verified.png` | Service restoration; demonstrating multi-stage Nikto rescan dropping findings from 11 down to 1 informational item (90.9% reduction). |
| **09:30 - 10:00** | **Conclusion & Enterprise Roadmap** | Enterprise defense-in-depth model in `README.md` | Summary of lessons learned: code/data separation, middleware hardening, real-time SIEM logging, and closing remarks. |

---

## 🎙️ Spoken Presentation Script

### 1. Introduction (00:00 - 01:15)
> "Hello everyone, and welcome to my presentation on Task 5: the Capstone Project and Incident Response Simulation for the ApexPlanet Cybersecurity and Ethical Hacking Internship Program. My name is Adarsh.
> 
> Over the course of this capstone, our goal was to bridge the gap between offensive penetration testing and defensive incident response. We deployed Damn Vulnerable Web Application on an isolated Kali Linux testbed bound strictly to the local loopback address at 127.0.0.1. By combining the OWASP Web Security Testing Guide with the NIST SP 800-61 incident response framework, we validated five critical web vulnerabilities, analyzed server access logs to detect active intrusion signatures, performed service containment, and implemented defense-in-depth mitigations."

### 2. Reconnaissance & Fingerprinting (01:15 - 02:30)
> "In our reconnaissance phase, we audited network interfaces and verified active listening sockets. Using `ss -tulpn`, we confirmed Apache was listening on port 80. A targeted Nmap service scan fingerprinted the web server as Apache version 2.4.68 Debian, while port 443 remained closed.
> 
> We then initiated an automated baseline vulnerability scan using Nikto. The scanner returned 11 items, highlighting missing security headers, four exposed directories with directory browsing enabled, an accessible .dockerignore file, and the application login portal."

### 3. Vulnerability Exploitation (02:30 - 05:15)
> "Moving into offensive exploitation:
> First, in the SQL Injection module, a baseline query for user ID 1 returned the administrator record. By injecting a boolean tautology—`1' OR '1'='1`—the backend SQL logic was broken, and the server dumped all five user accounts.
> 
> Next, for Cross-Site Scripting, we verified both Reflected and Stored variants. Reflected XSS executed an immediate alert dialog in the browser DOM, while Stored XSS persisted within the guestbook database, triggering an alert whenever the page was accessed.
> 
> For OS Command Injection, the application allowed ping diagnostics. By appending a semicolon and `whoami`, we achieved arbitrary shell execution, discovering the process was running as `www-data`.
> 
> Finally, in Local File Inclusion, utilizing directory traversal sequences—`../../../../etc/passwd`—allowed us to traverse outside the document root and disclose system user accounts."

### 4. Incident Detection & Containment (05:15 - 07:45)
> "Now switching to our Blue Team defensive posture:
> In the detection phase, we monitored `/var/log/apache2/access.log`. By constructing a custom forensic regular expression searching for patterns like `etc/passwd`, `union`, `select`, `script`, and `or.*=`, we extracted the attacker's IP—127.0.0.1—and correlated every attack URI.
> 
> To contain the active incident, we executed emergency service isolation using `systemctl stop apache2`. This immediately closed the listening socket on port 80, terminating all active exploit channels and preserving disk logs for forensic analysis."

### 5. Eradication, Hardening & Verification (07:45 - 09:30)
> "During eradication, we implemented four core controls:
> 1. We refactored the SQL query logic using PDO prepared statements and verified syntax with `php -l`.
> 2. We disabled directory indexing by injecting `Options -Indexes` into Apache's `000-default.conf`, validated with `apache2ctl configtest`.
> 3. We deployed `Strict-Transport-Security` and `Permissions-Policy` HTTP headers.
> 4. We quarantined the exposed `.dockerignore` file, confirming it returned an HTTP 404 Not Found.
> 
> In the recovery phase, we brought Apache and MariaDB back online and performed iterative Nikto audits. Our findings systematically dropped from 11 items down to 4, then to 2, and finally to just 1 single informational item—the expected login page. That represents a 90.9% reduction in scanner alerts."

### 6. Conclusion (09:30 - 10:00)
> "To conclude, Task 5 demonstrated that true cybersecurity requires understanding both sides of the coin: how attackers identify and exploit flaws, and how defenders detect, contain, and engineer permanent solutions. Thank you for your time."
