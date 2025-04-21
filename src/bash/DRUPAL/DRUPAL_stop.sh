#!/bin/bash

# Config
MYSQL_CONTAINER=mysql_drupal
DRUPAL_CONTAINER=drupal_site
NETWORK_NAME=drupal_local_net

# Stop and remove containers
docker rm -f $DRUPAL_CONTAINER $MYSQL_CONTAINER

# Remove custom network
docker network rm $NETWORK_NAME

echo "Drupal and MySQL containers stopped and cleaned up."

