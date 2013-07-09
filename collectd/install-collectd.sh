#!/bin/bash

echo "entering /tmp ..."
cd /tmp 

echo -ne "installing build-essential ..."
apt-get install build-essential > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE"; fi


#Dependencies for the write_http plugin
#apt-get install libcurl4-gnutls-dev librtmp-dev

echo "installing dependencies for write_mongo ..."

echo -ne "cloning mongoc project ..."
git clone https://github.com/mongodb/mongo-c-driver.git libmongoc > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log; fi

echo "entering libmongoc ..."
cd libmongoc

echo -ne "checking v.0.7.1 version ..."
git checkout v0.7.1 > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log; fi

echo -ne "compiling lib(can take a while) ..."
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


echo "installing collectd ..."

echo -ne "fetching sources files from collectd.org ..."
wget http://collectd.org/files/collectd-5.3.0.tar.bz2 > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log; fi

echo -ne "decompressing files ..."
tar jxf collectd-5.3.0.tar.bz2 > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log; fi

echo "entering collectd-x.y.z ..."
cd collectd-5.3.0

echo -ne "configuring collectd(can take a while) ..."
./configure > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log; fi

echo -ne "installing collectd(can take a while) ..."
make all install > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log; fi

echo "exiting collectd-x.y.z"
cd ..

echo "configuring collectd ..."
echo -ne "fetching collectd.conf ..."
wget https://github.com/fabienfoerster/monitoring-collectd/blob/master/collectd/config/collectd.conf > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log; fi

echo -ne "replacing collectd.conf ..."
mv collectd.conf /opt/collectd/etc/collectd.conf
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log; fi

echo -ne "fetching types.db.custom ..."
wget https://github.com/fabienfoerster/monitoring-collectd/blob/master/collectd/config/types.db.custom > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log; fi

echo -ne "replacing types.db.custom ..."
mv types.db.custom /opt/collectd/share/collectd/types.db.custom
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log; fi


