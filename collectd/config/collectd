#! /bin/sh
# /etc/init.d/collectd
#

# Some things that run always
touch /var/lock/collectd > /dev/null 2> /dev/null
if [ "$?" != "0" ];then echo "You must be root to execute this service.";exit 1;fi;

do_start(){
    echo -n "starting collectd ... "
    pidof -s collectd > /dev/null
    if [ "$?" = "0" ]
    then
        echo "FAILURE"
        echo "collectd is already running"
    else
        /opt/collectd/sbin/collectd
        if [ "$?" = "0" ];then echo "OK"; else echo "FAILURE";fi
    fi
}

do_stop(){
    echo -n "stopping collectd ... "
    pidofcollectd=`pidof -s collectd`
    if [ "$?" = "0" ]
    then
    kill -9 $pidofcollectd
        if [ "$?" = "0" ];then echo "OK"; else echo "FAILURE";fi
    else
        echo "FAILURE"
        echo "collectd is not running"
    fi
}

do_restart(){
    do_stop
    do_start
}

# Carry out specific functions when asked to by the system
case "$1" in
  start)
    do_start
    ;;
  stop)
    do_stop
    ;;
  restart)
    do_restart
    ;;
  *)
    echo "Usage: /etc/init.d/blah {start|stop|restart}"
    exit 1
    ;;
esac

exit 0
