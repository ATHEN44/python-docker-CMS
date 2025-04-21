#!/bin/bash

# Define the Docker Compose YAML File and Network Name
COMPOSE_FILE="docker-compose.yml"
NETWORK_NAME="gravcms_network"

# Stop and remove the containers created by Docker Compose
echo "Stopping and removing Docker containers..."
docker-compose down

# Remove associated Docker volumes (this will remove both the GravCMS and MySQL data volumes)
echo "Removing Docker volumes..."
docker volume rm $(docker volume ls -q --filter "name=gravcms_network")

# Remove the Docker network
echo "Removing Docker network $NETWORK_NAME..."
docker network rm $NETWORK_NAME

# Clean up unused Docker images, containers, and volumes
echo "Cleaning up unused Docker resources..."
docker system prune -f

echo "GravCMS environment and related Docker resources have been removed successfully."

