#!/bin/bash

# Environment
MYSQL_CONTAINER=mysql_joomla
JOOMLA_CONTAINER=joomla_site
NETWORK_NAME=joomla_local_net

# Stop and remove containers
docker rm -f $JOOMLA_CONTAINER $MYSQL_CONTAINER

# Remove network
docker network rm $NETWORK_NAME

echo "Joomla and MySQL containers stopped and removed."

