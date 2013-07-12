#!/bin/bash

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi


usage() {
    echo "usage: $0 -s server_name -p server_port"
    echo "-s server_name : the name of the server you want to send the collected data"
    echo "-p server_port : the port of the server you want to send the collected data"
}

server_name=""
server_port=""

while getopts ":hs:p:i:" option; do
    case "$option" in 
        s) server_name="$OPTARG" ;;
        p) server_port="$OPTARG" ;;
        :)  echo "Error: -$OPTARG requires an argument" 
            usage
            exit 1            
            ;;
        h) usage
           exit 0
           ;;
        ?)  echo "Error: unknown option -$OPTARG" 
        usage
        exit 1
        ;;
    esac
done

if [ -z "$server_name" ]; then
    echo "Error : the server_name argument must be specify"
    usage
    exit 1
fi

if [ -z "$server_port" ]; then
    echo "Error : the server_port argument must be specify"
    usage
    exit 1
fi

echo -ne "fetching configure file ..."
wget https://raw.github.com/fabienfoerster/yourcast-monitoring/master/collectd/config/collectd-server.conf > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log; fi


echo "modifing configure values"
sed -i "s/{{server_name}}/$server_name/" collectd-server.conf
sed -i "s/{{server_port}}/$server_port/" collectd-server.conf

echo -ne "replacing configure file ..."
mv collectd-server.conf /opt/collectd/etc/collectd.conf
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log; fi


