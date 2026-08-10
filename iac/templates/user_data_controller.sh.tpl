#!/bin/bash
set -e

TARGET_IP="${target_ip}"

echo "========================================"
echo " Ansible Controller Bootstrap"
echo " Target: $TARGET_IP"
echo "========================================"

# --- Write Ansible SSH private key (controller → target) ---
echo "[+] Writing Ansible SSH key..."
mkdir -p /home/ubuntu/.ssh
cat > /home/ubuntu/.ssh/ansible_key << 'SSHKEY'
${private_key}
SSHKEY
chmod 600 /home/ubuntu/.ssh/ansible_key
chown -R ubuntu:ubuntu /home/ubuntu/.ssh

# --- Install Ansible ---
echo "[+] Installing Ansible..."
apt-get update -y
apt-get install -y software-properties-common git
apt-add-repository -y ppa:ansible/ansible
apt-get update -y
apt-get install -y ansible python3-pip
pip3 install docker
ansible-galaxy collection install community.docker
# --- Clone the repo to get the latest playbook ---
echo "[+] Cloning repo..."
REPO_DIR="/home/ubuntu/trf_ansible_cmdb"
git clone https://github.com/chouleang/trf_ansible_cmdb.git "$REPO_DIR"

# --- Write inventory with custom SSH key ---
echo "[+] Writing inventory..."
mkdir -p /etc/ansible
cat > /etc/ansible/inventory << EOF
[web_servers]
$TARGET_IP ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/.ssh/ansible_key
EOF

# --- Run the playbook from the cloned repo ---
echo "[+] Running Ansible playbook against $TARGET_IP..."
ansible-playbook -i /etc/ansible/inventory "$REPO_DIR/ansible/playbooks/docker-nginx.yml"

echo "[✓] Bootstrap complete."