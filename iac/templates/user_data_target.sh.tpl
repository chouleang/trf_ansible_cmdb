#!/bin/bash
set -e

echo "[+] Adding Ansible controller public key to authorized_keys..."

# Append the terraform-generated public key so the controller can SSH in
echo '${ansible_public_key}' >> /home/ubuntu/.ssh/authorized_keys

echo "[✓] Ansible controller key added."
