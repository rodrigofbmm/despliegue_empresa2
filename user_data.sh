#!/bin/bash

exec > >(tee /var/log/user-data.log) 2>&1
set -e

echo "=== USER DATA SCRIPT STARTED ==="

# Update 
dnf update -y --allowerasing --skip-broken || echo "Update completed with warnings"

# Install dependencies
dnf install -y git curl unzip tar --allowerasing

# Install
cd /opt
curl -fsSL https://deno.land/x/install/install.sh -o install_deno.sh
chmod +x install_deno.sh
DENO_INSTALL=/opt/deno ./install_deno.sh
echo 'export DENO_INSTALL=/opt/deno' >> /etc/profile
echo 'export PATH=$DENO_INSTALL/bin:$PATH' >> /etc/profile
export DENO_INSTALL=/opt/deno
export PATH=$DENO_INSTALL/bin:$PATH

# Clone the new project
git clone https://github.com/rodrigofbmm/curly-octo-computing-machine.git /home/ec2-user/app
chown -R ec2-user:ec2-user /home/ec2-user/app

# Deno app
cat <<EOF > /etc/systemd/system/deno-app.service
[Unit]
Description=Deno Web App
After=network.target

[Service]
User=ec2-user
WorkingDirectory=/home/ec2-user/app
Environment=PATH=/opt/deno/bin:/usr/local/bin:/usr/bin:/bin
Environment=FRESH_HOST=0.0.0.0
ExecStart=/opt/deno/bin/deno task start
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Start service
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable deno-app.service
systemctl start deno-app.service

echo "=== USER DATA SCRIPT COMPLETED ==="
