#!/bin/bash

# Define container and network names
MYSQL_CONTAINER=mysql_wp
WORDPRESS_CONTAINER=wordpress_wp
NETWORK_NAME=wp_local_net

# Stop and remove containers
docker rm -f $WORDPRESS_CONTAINER $MYSQL_CONTAINER

# Remove network
docker network rm $NETWORK_NAME

echo "🧹 WordPress and MySQL containers are stopped and cleaned up."

