#!/bin/bash

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi


usage() {
    echo "usage: $0 -j jdk_directory -s server_name -p server_port -i interval"
    echo "-s server_name : the name of the server you are installing this"
    echo "-p server_port : the port of the server you want to listen for receiving the data"
}

server_name=""
server_port=""

while getopts ":hj:s:p:" option; do
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


echo "entering /tmp"
cd /tmp 

echo -ne "installing gcc and co ..."
apt-get install -y build-essential > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK";
else
yum -y groupinstall “Development Tools” > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi
fi


#Dependencies for the write_http plugin
#apt-get install libcurl4-gnutls-dev librtmp-dev

echo "installing dependencies for write_mongo ..."

echo -ne "cloning mongoc project ..."
git clone https://github.com/mongodb/mongo-c-driver.git libmongoc > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo "entering libmongoc"
cd libmongoc

echo -ne "checking v.0.7.1 version ..."
git checkout v0.7.1 > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo -ne "compiling lib(can take a while) ..."
make > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo -ne "installing lib ..."
make install > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo -ne "create symbolic link for libmongoc in /lib/ ..."
ln -sf /usr/local/lib/libmongoc.so.0.7 /lib/ > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo -ne "create symbolic link for libbson in /lib/ ..."
ln -sf /usr/local/lib/libbson.so.0.7 /lib/ > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo "exiting libmongoc"
cd ..

echo -ne "deleting libmongoc repo ..."
rm -rf libmongoc
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

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
rm -rf collectd-5.3.0 > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo -ne "deleting collectd-x.y.z.tar.bz2 ..."
rm -rf collectd-5.3.0.tar.bz2 > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo -ne "fetching types.db.custom ..."
wget https://raw.github.com/fabienfoerster/yourcast-monitoring/master/collectd/config/types.db.custom > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo -ne "replacing types.db.custom ..."
mv types.db.custom /opt/collectd/share/collectd/types.db.custom > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo -ne "fetching configuration file ..."
wget https://raw.github.com/fabienfoerster/yourcast-monitoring/master/collectd/config/collectd-server.conf > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo "modifing configure values ... "

sed -i "s/{{server_name}}/$server_name/" collectd-server.conf 
sed -i "s/{{server_port}}/$server_port/" collectd-server.conf

echo -ne "replacing configure file ... "
mv collectd-server.conf /opt/collectd/etc/collectd.conf > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo -n "fetching service script ... "
wget "https://raw.github.com/fabienfoerster/yourcast-monitoring/master/collectd/config/collectd" > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo -n "becoming executable ... "
chmod +x collectd > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo -n "moving service script to /etc/init.d ... "
mv collectd /etc/init.d/collectd > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo -n "adding script to boot sequence ... "
update-rc.d collectd defaults > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; 
else 
chkconfig --level 123456 collectd > /dev/null 2> /tmp/collectd.log
if [ "$?" != "0" ]; then echo "FAILURE";cat /tmp/collectd.log;exit 1; fi
chkconfig --add collectd > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi
fi

echo -n "starting collectd ..."
/opt/collectd/sbin/collectd > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo "Done"
