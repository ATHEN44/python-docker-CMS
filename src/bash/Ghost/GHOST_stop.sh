#!/bin/bash

# Config
MYSQL_CONTAINER=mysql_ghost
GHOST_CONTAINER=ghost_blog
NETWORK_NAME=ghost_local_net

# Stop and remove containers
docker rm -f $GHOST_CONTAINER $MYSQL_CONTAINER

# Remove network
docker network rm $NETWORK_NAME

echo "Ghost and MySQL containers stopped and removed."

