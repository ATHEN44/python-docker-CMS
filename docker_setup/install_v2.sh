#!/bin/bash


# Update system package index
echo "Updating system package index..."
sudo apt update -y

# Install required dependencies
echo "Installing dependencies..."
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common lsb-release

# Add Docker's official GPG key
echo "Adding Docker's GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository to APT sources (using a generic URL)
echo "Adding Docker repository..."
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu focal stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index again after adding the Docker repo
echo "Updating package index..."
sudo apt update -y

# Install Docker CE (Community Edition)
echo "Installing Docker..."
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Start Docker service and enable it to start on boot
echo "Starting Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

# Optionally, add current user to Docker group (for non-root usage)
echo "Adding user to the Docker group..."
sudo usermod -aG docker $USER

# Verify Docker installation
echo "Verifying Docker installation..."
docker --version

# Check if Docker is running
echo "Checking Docker status..."
sudo systemctl status docker | grep Active

echo "Docker installation completed! Log out and log back in to use Docker without 'sudo'."

