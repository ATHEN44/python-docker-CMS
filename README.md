# this program starts and stops docker containers with the following 5 Content Management systems (all using MySQL):

drupal
wordpress
grav
ghost
joomla

# prerequisites include:

docker, docker-compose, and all of their necessary requirements

an install script for docker is provided in the docker_install directory when you clone this repository.

# overview:

usage: main.py [-h] [--start {Drupal,Ghost,Grav,Joomla,Wordpress}] [--port PORT] [--stop {Drupal,Ghost,Grav,Joomla,Wordpress}] [--list] [--defaults] [--dbname DBNAME] [--dbuser DBUSER] [--dbpass DBPASS] [--dbroot DBROOT] [--cleanup]

start and stop a number of CMS systems (as docker containers)

options:
  -h, --help            show this help message and exit
  --start {Drupal,Ghost,Grav,Joomla,Wordpress}
                        the name of the cms
  --port PORT           the port to run the docker container on
  --stop {Drupal,Ghost,Grav,Joomla,Wordpress}
                        the name of the cms
  --list                list all CMSs
  --defaults            list default credentials
  --dbname DBNAME       mysql database name
  --dbuser DBUSER       mysql database user
  --dbpass DBPASS       mysql database password
  --dbroot DBROOT       mysql database root password
  --cleanup             cleanup files all docker related files and runs docker valume --prune
