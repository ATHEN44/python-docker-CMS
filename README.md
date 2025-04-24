# this program starts and stops docker containers with the following 5 Content Management systems (all using MySQL):

drupal<br>
wordpress<br>
grav<br>
ghost<br>
joomla<br>

# prerequisites include:

docker, docker-compose, and all of their necessary requirements

an install script for docker is provided in the docker_install directory when you clone this repository -- because i always get confused doing trying to do it.

# overview:

usage: main.py [-h] [--start {Drupal,Ghost,Grav,Joomla,Wordpress}] [--port PORT] [--stop {Drupal,Ghost,Grav,Joomla,Wordpress}] [--list] [--defaults] [--dbname DBNAME] [--dbuser DBUSER] [--dbpass DBPASS] [--dbroot DBROOT] [--cleanup]

start and stop a number of CMS systems (as docker containers)

options:<br>
  -h, --help            show this help message and exit<br>
  --start {Drupal,Ghost,Grav,Joomla,Wordpress}<br>
                        the name of the cms<br>
  --port PORT           the port to run the docker container on<br>
  --stop {Drupal,Ghost,Grav,Joomla,Wordpress}<br>
                        the name of the cms<br>
  --list                list all CMSs<br>
  --defaults            list default credentials<br>
  --dbname DBNAME       mysql database name<br>
  --dbuser DBUSER       mysql database user<br>
  --dbpass DBPASS       mysql database password<br>
  --dbroot DBROOT       mysql database root password<br>
