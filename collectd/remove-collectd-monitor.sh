#!/bin/bash

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

service collectd stop

echo "removing dependencies .."
rm /usr/local/include/bcon.h
rm /usr/local/include/bson.h
rm /usr/local/include/mongo.h
rm /usr/local/lib/libmongoc*
rm /usr/local/lib/libbson*
rm /lib/libmongoc*
rm /lib/libbson*

echo -n "removing collectd ..."
rm -rf /opt/collectd > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo -n "removing collectd from boot sequence ..."
update-rc.d -f  collectd remove > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo -n "removing service script ..."
rm /etc/init.d/collectd > /dev/null 2> /tmp/collectd.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/collectd.log;exit 1; fi

echo "Done."
