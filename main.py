#imports
import os,argparse,subprocess

#parse args
parser = argparse.ArgumentParser(description="start and stop a number of CMS systems (as docker containers)")
parser.add_argument("--start", type=str, help='the name of the cms', choices=['Drupal','Ghost','Grav', 'Joomla', 'Wordpress'])
parser.add_argument("--port", type=str, help='the port to run the docker container on')
parser.add_argument("--stop", type=str, help='the name of the cms',choices=['Drupal','Ghost','Grav', 'Joomla', 'Wordpress'])
parser.add_argument("--list", action='store_true', help='list all CMSs')
parser.add_argument("--defaults", action='store_true', help='list default credentials')
parser.add_argument("--dbname", type=str, help='mysql database name')
parser.add_argument("--dbuser", type=str, help='mysql database user')
parser.add_argument("--dbpass", type=str, help='mysql database password')
parser.add_argument("--dbroot", type=str, help='mysql database root password')
parser.add_argument("--cleanup", action='store_true', help="cleanup files all docker related files and runs docker valume --prune")
args = parser.parse_args()

#get current folder
current_folder = os.path.dirname(os.path.realpath(__file__))

CMSs = ['Drupal', 'Ghost', 'Grav', 'Joomla', 'Wordpress']

default_ports = ['8080','8081', '8082', '8083', '8084']

#search array for value
def locate(arr, v):
    return [i for i in arr if i == v][0]
#insert default values into argument array
#this must be done this way because the defaults are different for different the differnt CMS systems/containers and their respective mysql databases
def getDefaults(cms):
    a = []
    if args.port:
        #use the provided port (this may cause errors if the port is already in use.)
        #TODO fix port check error in bash script
        a.append(args.port)
    else:
        #append the default port for the container
        a.append(default_ports[CMSs[cms]])
    if args.dbname:
        a.append(args.dbname)
    else:
        a.append(cms)
    if args.dbuser:
        a.append(args.dbuser)
    else:
        a.append(cms)
    if args.dbpass:
        a.append(args.dbpass)
    else:
        a.append(cms)
    if args.dbroot:
        a.append(args.dbroot)
    else:
        a.append("rootpassword")
    return a

#handle list arg
if args.list:
    print('Currently Supported CMSs')
    for i in CMSs:
        print(i)
    exit(0)

elif args.defaults:
    print('where <CMS Name> is one of the following: '+ str(CMSs))
    print('mysql database name: <CMS Name>')
    print('mysql database user: <CMS Name>')
    print('mysql database password: <CMS Name>')
    print('mysql database root password: rootpassword')
    exit(0)

#handle startups
elif args.start:
    if args.start not in CMSs: 
        print('missing required argument --port')
        exit(-1)
    
    #set default values for database name, user, password and rootpassword
    argv_v = getDefaults(args.start)  

    print(current_folder)
    p = None
    o = args.start
    if o.lower() == 'wordpress':
        p = subprocess.run([current_folder+'/src/bash/WP/WP_start.sh']+argv_v,capture_output=True)
    elif o.lower() == 'drupal':
        p = subprocess.run([current_folder+'/src/bash/DRUPAL/DRUPAL_start.sh']+argv_v,capture_output=True)
    elif o.lower() == 'ghost':
        p = subprocess.run([current_folder+'/src/bash/Ghost/GHOST_start.sh']+argv_v,capture_output=True)
    elif o.lower() == 'joomla':
        p = subprocess.run([current_folder+'/src/bash/JOOMLA/JOOMLA_start.sh']+argv_v,capture_output=True)
    elif o.lower() == 'grav':
        p = subprocess.run([current_folder+'/src/bash/Grav/GRAV_start.sh']+argv_v, capture_output=True)
    
    print(p.stdout.decode('utf-8'))
    exit(0)
#handle stops
elif args.stop:
    p = None
    o = args.stop
    if o.lower() == 'wordpress':
        p = subprocess.run([current_folder+'/src/bash/WP/WP_stop.sh'],capture_output=True)
    elif o.lower() == 'drupal':
        p = subprocess.run([current_folder+'/src/bash/DRUPAL/DRUPAL_stop.sh'],capture_output=True)
    elif o.lower() == 'ghost':
        p = subprocess.run([current_folder+'/src/bash/Ghost/GHOST_stop.sh'],capture_output=True)
    elif o.lower() == 'joomla':
        p = subprocess.run([current_folder+'/src/bash/JOOMLA/JOOMLA_stop.sh'],capture_output=True)
    elif o.lower() == 'grav':
        p = subprocess.run([current_folder+'/src/bash/Grav/GRAV_stop.sh'], capture_output=True)
    
    print(p.stdout.decode('utf-8'))
    exit(0) 
