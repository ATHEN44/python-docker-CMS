#!/bin/bash

# Exit on any error
set -e

# Stop all running Docker containers
echo "Stopping all running Docker containers..."
sudo docker stop $(sudo docker ps -q)

# Remove all Docker containers (including stopped ones)
echo "Removing all Docker containers..."
sudo docker rm $(sudo docker ps -a -q)

# Remove all Docker images
echo "Removing all Docker images..."
sudo docker rmi $(sudo docker images -q)

# Remove all Docker volumes
echo "Removing all Docker volumes..."
sudo docker volume prune -f

# Remove all Docker networks (except the default ones)
echo "Removing all Docker networks..."
sudo docker network prune -f

# Uninstall Docker
echo "Uninstalling Docker..."
sudo apt-get purge -y docker-ce docker-ce-cli containerd.io

# Remove Docker's dependencies and any residual config files
echo "Cleaning up unused dependencies..."
sudo apt-get autoremove -y
sudo apt-get autoclean

# Remove Docker's data (optional but recommended for complete removal)
echo "Removing Docker data directories..."
sudo rm -rf /var/lib/docker

# Verify Docker has been removed
echo "Verifying Docker removal..."
if ! command -v docker &> /dev/null
then
    echo "Docker has been completely removed from your system."
else
    echo "Docker removal failed. Please check the error messages above."
fi

