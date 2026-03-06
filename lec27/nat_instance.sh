#!/bin/bash
set -xe
# Update packages
dnf update -y
# Enable IP forwarding
echo "net.ipv4.ip_forward = 1" > /etc/sysctl.d/99-nat.conf
sysctl -p /etc/sysctl.d/99-nat.conf
# Install iptables
dnf install -y iptables-services
# Configure NAT (MASQUERADE)
iptables -t nat -A POSTROUTING -o ens5 -j MASQUERADE
iptables -F FORWARD
# Save iptables rules so they persist after reboot
iptables-save > /etc/sysconfig/iptables
# Enable and start iptables service
systemctl enable --now  iptables
