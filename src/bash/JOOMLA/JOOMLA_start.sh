#!/bin/bash

# Exit on error
set -e

# Environment variables
DB_NAME=$2
DB_USER=$3
DB_PASSWORD=$4
DB_ROOT_PASSWORD=$5
MYSQL_CONTAINER=mysql_joomla
JOOMLA_CONTAINER=joomla_site
NETWORK_NAME=joomla_local_net

# Create a custom Docker bridge network limited to localhost
docker network create \
  --driver bridge \
  --subnet 172.26.0.0/16 \
  --gateway 172.26.0.1 \
  --opt "com.docker.network.bridge.host_binding_ipv4"="127.0.0.1" \
  "$NETWORK_NAME"

# Run MySQL container
docker run -d \
  --name $MYSQL_CONTAINER \
  --network $NETWORK_NAME \
  -e MYSQL_DATABASE=$DB_NAME \
  -e MYSQL_USER=$DB_USER \
  -e MYSQL_PASSWORD=$DB_PASSWORD \
  -e MYSQL_ROOT_PASSWORD=$DB_ROOT_PASSWORD \
  mysql:latest

# Run Joomla container
docker run -d \
  --name $JOOMLA_CONTAINER \
  --network $NETWORK_NAME \
  -e JOOMLA_DB_HOST=$MYSQL_CONTAINER:3306 \
  -e JOOMLA_DB_USER=$DB_USER \
  -e JOOMLA_DB_PASSWORD=$DB_PASSWORD \
  -e JOOMLA_DB_NAME=$DB_NAME \
  -p 127.0.0.1:$1:80 \
  joomla:latest

echo "✅ Joomla is running at http://localhost:$1"

