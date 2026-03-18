#!/bin/bash
# Week 4 Assessment: Provisioning Script for wordpress-server
# This script automates system updates, tool installation, and EBS mounting.
set -e

echo "1. Updating system packages..."
sudo apt update -y [3]

echo "2. Installing Docker, Docker Compose, and AWS CLI..."
# We install AWS CLI now so Task 3 (backup script) will work later [4].
sudo apt install -y docker.io docker-compose awscli [3, 4]
sudo usermod -aG docker ubuntu [5]

echo "3. Preparing the EBS Volume (nvme1n1)..."
DEVICE="/dev/nvme1n1"
MOUNT_POINT="/mnt/mysql-data"

# Create the directory the application needs [3]
sudo mkdir -p $MOUNT_POINT [1]

# Format the volume only if it is not already formatted [1, 6]
if ! sudo file -s $DEVICE | grep -q 'ext4'; then
    echo "Formatting $DEVICE..."
    sudo mkfs -t ext4 $DEVICE [1]
fi

# Mount the EBS volume if it is not already mounted [6]
if ! mountpoint -q $MOUNT_POINT; then
    echo "Mounting $DEVICE to $MOUNT_POINT..."
    sudo mount $DEVICE $MOUNT_POINT [1]
fi

echo "4. Setting correct ownership and permissions..."
# Ensure the ubuntu user and Docker can write to the mount point [6]
sudo chown -R ubuntu:ubuntu $MOUNT_POINT [6]
sudo chmod -R 755 $MOUNT_POINT [6]

echo "Provisioning complete! Task 1 is finished."
