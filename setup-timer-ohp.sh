#!/bin/bash

clear

# Check if root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo 'Created by @gatot | Version 0.0.1'

# Read Input
echo 'Reconnection Timer for Globe No Load (OHP & SSHPLUS PROXY)'
echo ''
read -e -p 'Input name of service: ' -i 'ohpserver-ssh' SERNAME
read -e -p 'Input timer(seconds)' -i '55' TSEC

echo 'Getting reconn binary'
wget https://raw.githubusercontent.com/gatotx/reconnection-timer/main/reconn
mv reconn /usr/local/bin/reconn
chmod 755 /usr/local/bin/reconn

# Setup timer service
echo 'Setting up timer service'
cat <<EOF > /etc/systemd/system/reconn.service
[Unit]
Description=Reconnection Timer for OHP | @Jokerteam
Wants=network.target
After=network.target

[Service]
ExecStart=/usr/local/bin/reconn -service=$SERNAME -timer=$TSEC
Restart=always
RestartSec=3
[Install]
WantedBy=multi-user.target
EOF


# Enable on boot
echo 'Starting timer on boot'
systemctl enable reconn
systemctl start reconn

echo 'Setup completed!'
echo 'Check reconn status by typing systemctl status reconn'
