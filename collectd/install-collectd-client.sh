#!/bin/bash

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi


usage() {
    echo "usage: $0 -j jdk_directory "
}

dir_jdk=""

while getopts ":hj:" option; do
    case "$option" in 
        j) dir_jdk="$OPTARG" ;;
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


echo "entering /tmp"
cd /tmp 

echo -ne "installing gcc and co ..."
apt-get install build-essential > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK";
else
yum groupinstall “Development Tools” > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi
fi


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

