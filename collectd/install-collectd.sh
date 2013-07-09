#!/bin/bash

echo -ne "entering /tmp ..."
cd /tmp 
# Just to make sure you have the c-compiler linker and co

echo -ne "installing build-essential ..."
apt-get install build-essential
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE"; fi

## Plugin dependencies instalttion

#Dependencies for the write_http plugin
#apt-get install libcurl4-gnutls-dev librtmp-dev

#Dependencies for the write_mongo plugin
echo -ne "installing dependencies for write_mongo ..."

echo -ne "cloning mongoc project ..."
git clone https://github.com/mongodb/mongo-c-driver.git libmongoc
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE"; fi

echo -ne "entering libmongoc ..."
cd ligmongoc

echo -ne "checking v.0.7.1 version ..."
git checkout v0.7.1
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE"; fi

echo -ne "compiling lib ..."
make
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE"; fi

echo -ne "installing lib ..."
make install
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE"; fi

echo -ne "create symbolic link for libmongoc in /lib/ ..."
ln -sf /usr/local/lib/libmongoc.so.0.7 /lib/
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE"; fi

echo -ne "create symbolic link for libbson in /lib/ ..."
ln -sf /usr/local/lib/libbson.so.0.7 /lib/
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE"; fi

echo -ne "exiting libmongoc ..."
cd ..

echo -ne "installing dependencies for write_mongo ...OK"


#Get collectd and install it
echo -ne "installing collectd ..."

echo -ne "fetching sources files from collectd.org ..."
wget http://collectd.org/files/collectd-5.3.0.tar.bz2
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE"; fi

echo -ne "decompressing files ..."
tar jxf collectd-5.3.0.tar.bz2
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE"; fi

echo -ne "entering collectd-x.y.z ..."
cd collectd-5.3.0

echo -ne "configuring collectd ..."
./configure
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE"; fi

echo -ne "installing collectd ..."
make all install
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE"; fi



