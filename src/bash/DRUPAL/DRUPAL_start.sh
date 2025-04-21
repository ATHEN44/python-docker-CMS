#!/bin/bash

set -e

# Config
DB_NAME=$2
DB_USER=$3
DB_PASSWORD=$4
DB_ROOT_PASSWORD=$5
MYSQL_CONTAINER=mysql_drupal
DRUPAL_CONTAINER=drupal_site
NETWORK_NAME=drupal_local_net

# Create Docker bridge network restricted to localhost
docker network create \
  --driver bridge \
  --subnet 172.27.0.0/16 \
  --gateway 172.27.0.1 \
  --opt "com.docker.network.bridge.host_binding_ipv4"="127.0.0.1" \
  "$NETWORK_NAME"

# Run MySQL 8.x container
docker run -d \
  --name $MYSQL_CONTAINER \
  --network $NETWORK_NAME \
  -e MYSQL_DATABASE=$DB_NAME \
  -e MYSQL_USER=$DB_USER \
  -e MYSQL_PASSWORD=$DB_PASSWORD \
  -e MYSQL_ROOT_PASSWORD=$DB_ROOT_PASSWORD \
  mysql:latest

# Run Drupal container
docker run -d \
  --name $DRUPAL_CONTAINER \
  --network $NETWORK_NAME \
  -e DRUPAL_DB_HOST=$MYSQL_CONTAINER:3306 \
  -e DRUPAL_DB_NAME=$DB_NAME \
  -e DRUPAL_DB_USER=$DB_USER \
  -e DRUPAL_DB_PASSWORD=$DB_PASSWORD \
  -p 127.0.0.1:$1:80 \
  drupal:latest

echo "✅ Drupal is running at http://localhost:$1"

