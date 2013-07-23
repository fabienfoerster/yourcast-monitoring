#!/bin/bash

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi


usage() {
    echo "usage: $0 -j jdk_directory -s server_name -p server_port -i interval"
    echo "-j jdk_directory : the path to your jdk"
    echo "-s server_name : the name of the server you want to send the collected data"
    echo "-p server_port : the port of the server you want to send the collected data"
    echo "-i interval : the frequency you want to collect the data"
}

dir_jdk=""
server_name=""
server_port=""
interval=""

while getopts ":hj:s:p:i:" option; do
    case "$option" in 
        j) dir_jdk="$OPTARG" ;;
        s) server_name="$OPTARG" ;;
        p) server_port="$OPTARG" ;;
        i) interval="$OPTARG" ;;
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

if [ ! -d "$dir_jdk" ]; then
    echo "Error : the jdk_directory argument must be a directory"
    usage
    exit 1
fi

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

if ! [[ "$interval" =~ ^[0-9]+$ ]] ; then
    echo "Error : the interval must be a number"
    usage
    exit 1
fi


echo "entering /tmp"
cd /tmp 

echo -ne "installing needed dependencies(can take a little while) ..."
type apt-get >/dev/null 2>&1
if [ "$?" = "0" ]
then
    apt-get install build-essential > /dev/null 2> /tmp/collectd.log
    apt-get install python2.7 python-dev python-pip > /dev/null 2> /tmp/collectd.log
    pip install pymongo > /dev/null 2> /tmp/collectd.log
else
    yum groupinstall “Development Tools” > /dev/null 2> /tmp/collectd.log
    yum install python > /dev/null 2> /tmp/collectd.log
    yum install python-devel > /dev/null 2> /tmp/collectd.log
fi
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi


#Dependencies for the write_http plugin
#apt-get install libcurl4-gnutls-dev librtmp-dev


echo "installing collectd ..."

echo -ne "fetching sources files from collectd.org ..."
wget http://collectd.org/files/collectd-5.3.0.tar.bz2 > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo -ne "decompressing files ..."
tar jxf collectd-5.3.0.tar.bz2 > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo "entering collectd-x.y.z"
cd collectd-5.3.0

echo -ne "configuring collectd(can take a while) ..."
./configure --with-java="$dir_jdk" > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo -ne "installing collectd(can take a while) ..."
make all install > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo "exiting collectd-x.y.z"
cd ..

echo -ne "deleting collectd-x.y.z ..."
rm -rf collectd-5.3.0
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo -ne "deleting collectd-x.y.z.tar.bz2 ..."
rm -rf collectd-5.3.0.tar.bz2
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo -ne "fetching types.db.custom ..."
wget https://raw.github.com/fabienfoerster/yourcast-monitoring/master/collectd/config/types.db.custom > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo -ne "replacing types.db.custom ..."
mv types.db.custom /opt/collectd/share/collectd/types.db.custom
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo -ne "fetching configuration file ..."
wget https://raw.github.com/fabienfoerster/yourcast-monitoring/master/collectd/config/collectd-client.conf > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo "modifing configure values ... "

sed -i "s/{{server_name}}/$server_name/" collectd-client.conf
sed -i "s/{{server_port}}/$server_port/" collectd-client.conf
sed -i "s/{{interval}}/$interval/" collectd-client.conf

echo -ne "replacing configure file ... "
mv collectd-client.conf /opt/collectd/etc/collectd.conf
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo -ne "fetching mongodb.py ..."
wget https://raw.github.com/fabienfoerster/yourcast-monitoring/master/collectd/config/mongodb.py > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo -ne "create python module directory ..."
mkdir -p /opt/collectd/share/collectd/python > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo -ne "moving mongodb.py to python module directory ..."
mv mongodb.py /opt/collectd/share/collectd/python/mongodb.py > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo -n "fetching service script ... "
wget https://raw.github.com/fabienfoerster/yourcast-monitoring/master/collectd/config/collectd > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo -n "becoming executable ... "
chmod +x collectd > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo -n "moving service script to /etc/init.d ... "
mv collectd /etc/init.d > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo -n "adding script to boot sequence ... "
update-rc.d collectd defaults > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; 
else 
chkconfig --add collectd > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi
fi

echo -n "starting collectd ..."
/opt/collectd/sbin/collectd > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo "Done"

