# 03 — Lab Architecture & Network Topology

## 1. Architectural Overview

The assessment environment was hosted on an isolated Kali Linux virtual machine. All testing communications and application traffic occurred over the local loopback interface (`127.0.0.1`), ensuring an air-gapped test bed where no traffic crossed external network boundaries.

![Lab Architecture Diagram](../diagrams/network-diagram.png)

---

## 2. Host Network Configuration

The network configuration was audited directly using the standard Linux utility `ip addr` (Evidence: [02-Apache-Port-80.png](../evidence/reconnaissance/02-Apache-Port-80.png)):

| Interface | IP Address / Netmask | State | Operational Role |
|---|---|---|---|
| `lo` | `127.0.0.1/8` | `UNKNOWN` (UP) | Localhost loopback interface utilized for all penetration testing, HTTP communications, and service verification. |
| `eth0` | `10.0.2.15/24` | `UP` | Internal hypervisor NAT network adapter (dynamic routing, no internet exposure used during engagement). |
| `eth1` | `192.168.56.103/24` | `UP` | Host-only private virtual adapter used for secure virtualization host communication. |

---

## 3. Technology Stack & Service Mapping

| Component | Software & Version | Binding / Port | Filesystem Path | Operational Role |
|---|---|---|---|---|
| **Operating System** | Kali Linux (Debian-based) | N/A | `/` | Attack simulation and defensive response workstation. |
| **Web Server Daemon** | Apache HTTP Server `2.4.68 (Debian)` | `*:80` (TCP LISTEN) | `/etc/apache2/` | Core HTTP listener and reverse handler for PHP scripts. |
| **Web Root** | Apache Document Root | `http://127.0.0.1/DVWA/` | `/var/www/html/DVWA/` | Target web application directory containing DVWA components. |
| **Application Layer** | Damn Vulnerable Web Application (DVWA) | PHP 8.x Runtime | `/var/www/html/DVWA/` | Intentionally vulnerable web application test bed. |
| **Database Engine** | MariaDB Server | Local UNIX Socket / `3306` | `/var/lib/mysql/` | Backend relational database storing DVWA tables (`users`, etc.). |
| **Access Logging** | Apache Access Log Facility | Local file append | `/var/log/apache2/access.log` | Centralized web access audit trail used for incident detection. |
| **Configuration File** | Apache Default VirtualHost | System config | `/etc/apache2/sites-available/000-default.conf` | Virtual host definition modified during system hardening. |

---

## 4. Architectural Boundaries & Isolation Controls

1. **Air-Gapped Loopback Confinement**:
   - The primary application binding verified via `ss -tulpn` confirmed Apache listening across IPv4 interfaces, but the target application was accessed exclusively via `127.0.0.1`.
2. **Localhost Process Privilege Boundary**:
   - The web server process executed under the restricted system service account `www-data` (UID 33, GID 33).
   - This boundary prevents web application execution from gaining root system privileges directly, unless an unpatched privilege escalation path exists.
3. **Database Confinement**:
   - The MariaDB server runs locally and communicates with DVWA via local sockets/localhost, eliminating exposure of database ports to remote networks.
