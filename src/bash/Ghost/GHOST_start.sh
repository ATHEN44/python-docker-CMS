#!/bin/bash

set -e

# Configuration
DB_NAME=$2
DB_USER=$3
DB_PASSWORD=$4
DB_ROOT_PASSWORD=$5
MYSQL_CONTAINER=mysql_ghost
GHOST_CONTAINER=ghost_blog
NETWORK_NAME=ghost_local_net

# Cleanup (optional)
docker rm -f $MYSQL_CONTAINER $GHOST_CONTAINER 2>/dev/null || true
docker network rm $NETWORK_NAME 2>/dev/null || true

# Create internal network (localhost-only)
docker network create \
  --driver bridge \
  --subnet 172.28.0.0/16 \
  --gateway 172.28.0.1 \
  --opt "com.docker.network.bridge.host_binding_ipv4"="127.0.0.1" \
  "$NETWORK_NAME"

# Start MySQL
docker run -d \
  --name $MYSQL_CONTAINER \
  --network $NETWORK_NAME \
  -e MYSQL_DATABASE=$DB_NAME \
  -e MYSQL_USER=$DB_USER \
  -e MYSQL_PASSWORD=$DB_PASSWORD \
  -e MYSQL_ROOT_PASSWORD=$DB_ROOT_PASSWORD \
  mysql:8.3


# Wait for MySQL (runs a test connection from a temporary container)
until docker run --rm \
  --network $NETWORK_NAME \
  mysql:latest \
  sh -c "mysql -h $MYSQL_CONTAINER -u$DB_USER -p$DB_PASSWORD -e 'SELECT 1' $DB_NAME" >/dev/null 2>&1; do
    sleep 2
done

echo "✅ MySQL is ready..."

# Start Ghost
docker run -d \
  --name $GHOST_CONTAINER \
  --network $NETWORK_NAME \
  -e database__client=mysql \
  -e database__connection__host=$MYSQL_CONTAINER \
  -e database__connection__user=$DB_USER \
  -e database__connection__password=$DB_PASSWORD \
  -e database__connection__database=$DB_NAME \
  -e url=http://localhost:$1 \
  -p 127.0.0.1:$1:2368 \
  ghost:latest

echo "Ghost is running at http://localhost:$1"

