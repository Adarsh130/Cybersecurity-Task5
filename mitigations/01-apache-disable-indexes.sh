#!/bin/bash
# ==============================================================================
# ApexPlanet Cybersecurity Internship - Task 5 Remediation
# Script: 01-apache-disable-indexes.sh
# Purpose: Disable directory listing (CWE-548) in Apache 000-default.conf
# ==============================================================================

set -euo pipefail

CONF_FILE="/etc/apache2/sites-available/000-default.conf"

echo "[*] Backing up existing VirtualHost configuration..."
cp "${CONF_FILE}" "${CONF_FILE}.bak.$(date +%F_%T)"

echo "[*] Injecting Options -Indexes directive..."
cat << 'EOF' > /tmp/vhost_patch.txt
	<Directory /var/www/html>
		Options -Indexes +FollowSymLinks
		AllowOverride None
		Require all granted
	</Directory>
EOF

# Insert directory block before closing </VirtualHost> tag
sed -i '/<\/VirtualHost>/e cat /tmp/vhost_patch.txt' "${CONF_FILE}"
rm -f /tmp/vhost_patch.txt

echo "[*] Verifying Apache syntax configuration..."
apache2ctl configtest

echo "[*] Reloading Apache service..."
systemctl reload apache2

echo "[+] Directory indexing successfully disabled and verified."
