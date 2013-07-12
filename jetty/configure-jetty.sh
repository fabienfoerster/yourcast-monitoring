#!/bin/bash

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

usage() {
    echo "usage: $0 -p path_to_jetty"
    echo "-p path_to_jetty : the path where you have install jetty"
}

path_to_jetty=""

while getopts ":hs:p:i:" option; do
    case "$option" in 
        p) path_to_jetty="$OPTARG" ;;
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

if [ ! -d "$path_to_jetty" ]; then
    echo "Error : the path_to_jetty argument must be a directory"
    usage
    exit 1
fi

echo "entering /tmp"
cd /tmp	

echo -ne "fetching jetty-jmx.xml ..."
wget https://raw.github.com/fabienfoerster/yourcast-monitoring/master/jetty/config/jetty-jmx.xml > /dev/null 2> /tmp/jetty.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/jetty.log; fi

echo -ne "replacing jetty-jmx.xml ..."
mv jetty-jmx.xml "$path_to_jetty/etc/jetty-jmx.xml"
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/jetty.log; fi

echo "Done"
echo "For error see above."

