#!/bin/bash
# ==============================================================================
# ApexPlanet Cybersecurity Internship - Task 5 Remediation
# Script: 04-quarantine-dockerignore.sh
# Purpose: Quarantine exposed build configuration artifacts (CWE-538)
# ==============================================================================

set -euo pipefail

TARGET_FILE="/var/www/html/DVWA/.dockerignore"
BACKUP_FILE="/var/www/html/DVWA/.dockerignore.bak"

if [ -f "${TARGET_FILE}" ]; then
    echo "[*] Relocating exposed artifact: ${TARGET_FILE}..."
    mv "${TARGET_FILE}" "${BACKUP_FILE}"
    chmod 600 "${BACKUP_FILE}"
    echo "[+] File quarantined successfully."
else
    echo "[-] File ${TARGET_FILE} not found or already relocated."
fi

echo "[*] Validating HTTP response..."
STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1/DVWA/.dockerignore)
echo "[*] HTTP Status Code for .dockerignore: ${STATUS_CODE}"

if [ "${STATUS_CODE}" -eq 404 ]; then
    echo "[+] Exposure eliminated. Verified with 404 Not Found."
else
    echo "[!] Warning: Received status ${STATUS_CODE}."
fi
