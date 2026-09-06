# Scripts Directory

## Operational Policy & Script Usage

In accordance with strict ethical penetration testing guidelines and project specifications, **no automated exploit scripts or weaponized attack payloads are stored in this directory**.

### Rationale

1. **Native Tooling Utilization**: All reconnaissance, scanning, and verification activities were conducted directly using standard Linux and penetration testing utilities natively packaged in Kali Linux (e.g., `nmap`, `nikto`, `curl`, `systemctl`, `sed`, `grep`).
2. **Defensive Documentation Integrity**: The primary objective of this capstone repository is vulnerability assessment, root cause analysis, incident detection, and defensive system hardening.
3. **Reproducibility via Commands**: Step-by-step terminal commands used throughout the engagement are documented explicitly in:
   - [Methodology Notes](../notes/methodology.md)
   - [Scanning Documentation](../docs/05-scanning.md)
   - [Incident Response Documentation](../docs/09-incident-response.md)
   - [Remediation Documentation](../docs/08-remediation.md)

If custom defensive automation scripts (such as automated log alerting or configuration compliance auditors) are authored in future phases, they will be reviewed and published here with complete inline annotations.
