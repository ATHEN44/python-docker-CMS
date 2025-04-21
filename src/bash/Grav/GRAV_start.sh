#!/bin/bash

PORT=$1
DB_NAME=$2
DB_USER=$3
DB_PASS=$4
DB_ROOT=$5


# Define Docker Compose YAML File
COMPOSE_FILE="docker-compose.yml"

# Define Docker network name for isolated communication
NETWORK_NAME="gravcms_network"

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "docker-compose not found! Please install Docker Compose first."
    exit 1
fi

# Create a docker-compose.yml file if it doesn't exist
cat > $COMPOSE_FILE <<EOF
version: "3.8"

services:
  db:
    image: mysql:latest
    container_name: grav_db
    environment:
      MYSQL_ROOT_PASSWORD: $DB_ROOT
      MYSQL_DATABASE: $DB_NAME
      MYSQL_USER: $DB_USER
      MYSQL_PASSWORD: $DB_PASS
    networks:
      - $NETWORK_NAME
    volumes:
      - db_data:/var/lib/mysql
    ports:
      - "3306:3306"
  
  grav:
    image: linuxserver/grav:latest
    container_name: grav_cms
    networks:
      - $NETWORK_NAME
    depends_on:
      - db
    ports:
      - "$PORT:80"
    volumes:
      - grav_data:/var/www/html
    restart: always

networks:
  $NETWORK_NAME:
    driver: bridge

volumes:
  db_data:
  grav_data:
EOF

# Create Docker Network
echo "Creating Docker network $NETWORK_NAME..."
docker network create $NETWORK_NAME || echo "Network $NETWORK_NAME already exists."

# Start containers using Docker Compose
echo "Starting Docker containers for GravCMS and MySQL..."
sudo docker-compose up -d

# Function to check if MySQL is ready
check_mysql_ready() {
  echo "Waiting for MySQL to be ready..."
  while ! docker exec grav_db mysqladmin --user=root --password=rootpassword --host=localhost --silent ping; do
    sleep 3
  done
  echo "MySQL is ready!"
}

# Wait for MySQL to be fully ready before starting GravCMS
check_mysql_ready

# Now you can access GravCMS at http://localhost:8000
echo "GravCMS is now set up and running at http://localhost:$PORT"

