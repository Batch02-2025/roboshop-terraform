#! /bin/bash

# Update the System
sudo dnf update -y
sudo dnf upgrade -y
sudo hostnamectl set-hostname ${var.name} --static # change the Hostname as per your requirement.

# Download the latest EPEL release RPM for RHEL 9
sudo curl -O https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm

# Install it manually
sudo rpm -ivh epel-release-latest-9.noarch.rpm

# Clean and refresh DNF
sudo dnf clean all
sudo dnf makecache

#  Install Basic Utilities

sudo dnf install vim wget git unzip net-tools bind-utils telnet traceroute nmap htop tree bash-completion iputils -y

# Security & Networking Tools
sudo dnf install -y tcpdump openssl openssh-clients

# Reboot
sudo reboot

