#!/bin/bash
#Temporary solution for collectd memory leak ( plugin write_mongodb )
#To be place in the folder /etc/cron.daily
service collectd stop
service collectd start
