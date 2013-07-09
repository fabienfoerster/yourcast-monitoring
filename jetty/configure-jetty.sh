#!/bin/bash

# $1 must be the location of the jetty folder

echo "entering /tmp"
cd /tmp	

echo -ne "fetching jetty-jmx.xml ..."
wget https://raw.github.com/fabienfoerster/yourcast-monitoring/master/jetty/config/jetty-jmx.xml > /dev/null 2> /tmp/jetty.log
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/jetty.log; fi

echo -ne "replacing jetty-jmx.xml ..."
mv jetty-jmx.xml "$1/etc/jetty-jmx.xml"
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/jetty.log; fi

echo -ne "adding jetty-jmx.xml to start.ini ..."
echo "etc/jetty-jmx.xml" >> "$1/start.ini"
if [ "$?" = "0" ]; then echo "OK"; else echo "FAILURE";cat /tmp/jetty.log; fi

echo "Done"
echo "For error see above."

