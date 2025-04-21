#!/bin/bash

# Exit on any error
set -e

# Define environment variables
DB_NAME=$2
DB_USER=$3
DB_PASSWORD=$4
DB_ROOT_PASSWORD=$5
MYSQL_CONTAINER=mysql_wp
WORDPRESS_CONTAINER=wordpress_wp
NETWORK_NAME=wp_local_net

# Create Docker network (bridge, only localhost access)
docker network create \
  --driver bridge \
  --subnet 172.25.0.0/16 \
  --gateway 172.25.0.1 \
  --opt "com.docker.network.bridge.host_binding_ipv4"="127.0.0.1" \
  "$NETWORK_NAME"

# Start MySQL container
docker run -d \
  --name $MYSQL_CONTAINER \
  --network $NETWORK_NAME \
  -e MYSQL_DATABASE=$DB_NAME \
  -e MYSQL_USER=$DB_USER \
  -e MYSQL_PASSWORD=$DB_PASSWORD \
  -e MYSQL_ROOT_PASSWORD=$DB_ROOT_PASSWORD \
  mysql:5.7

# Start WordPress container
docker run -d \
  --name $WORDPRESS_CONTAINER \
  --network $NETWORK_NAME \
  -e WORDPRESS_DB_HOST=$MYSQL_CONTAINER:3306 \
  -e WORDPRESS_DB_NAME=$DB_NAME \
  -e WORDPRESS_DB_USER=$DB_USER \
  -e WORDPRESS_DB_PASSWORD=$DB_PASSWORD \
  -p 127.0.0.1:$1:80 \
  wordpress:latest

echo "✅ WordPress is running at http://localhost:$1"

