#!/bin/bash

echo "entering /tmp ..."
cd /tmp 
# Just to make sure you have the c-compiler linker and co

echo -ne "installing build-essential ..."
apt-get install build-essential > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE"; fi

## Plugin dependencies instalttion

#Dependencies for the write_http plugin
#apt-get install libcurl4-gnutls-dev librtmp-dev

#Dependencies for the write_mongo plugin
echo "installing dependencies for write_mongo ..."

echo -ne "cloning mongoc project ..."
git clone https://github.com/mongodb/mongo-c-driver.git libmongoc > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log; fi

echo "entering libmongoc ..."
cd ligmongoc

echo -ne "checking v.0.7.1 version ..."
git checkout v0.7.1 > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log; fi

echo -ne "compiling lib ..."
make > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log; fi

echo -ne "installing lib ..."
make install > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log; fi

echo -ne "create symbolic link for libmongoc in /lib/ ..."
ln -sf /usr/local/lib/libmongoc.so.0.7 /lib/ > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log; fi

echo -ne "create symbolic link for libbson in /lib/ ..."
ln -sf /usr/local/lib/libbson.so.0.7 /lib/ > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log; fi

echo "exiting libmongoc ..."
cd ..

echo "installing dependencies for write_mongo ...OK"


#Get collectd and install it
echo "installing collectd ..."

echo -ne "fetching sources files from collectd.org ..."
wget http://collectd.org/files/collectd-5.3.0.tar.bz2 > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log; fi

echo -ne "decompressing files ..."
tar jxf collectd-5.3.0.tar.bz2 > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log; fi

echo "entering collectd-x.y.z ..."
cd collectd-5.3.0

echo -ne "configuring collectd ..."
./configure > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log; fi

echo -ne "installing collectd ..."
make all install > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log; fi

echo "installing collectd ...OK"


