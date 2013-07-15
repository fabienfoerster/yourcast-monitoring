#README

In this folder you will find some scripts and some config files to install and configure collectd.

This configuration will enable the following plugins :

  * cpu
  * interface
  * memory
  * java
  * genericjmx
    * memory_pool
    * loaded_classes
    * garbage_collector
    * memory-heap
    * memory-nonheap
    
##Prerequisite for the monitor version of collectd

To be sure all goes well be sure that you have the follwing programs up and running :
  * mongo 2.4.5
  * git

##Prerequisite for the client version of collectd

To be sure all goes well be sure that you have the follwing programs up and running :
  * jdk1.6.0_45
  * jetty7

##Installing collectd monitor/client version :

Just run the **install-collectd-monitor-1click.sh** ( or install-collectd-client-1click.sh) with the correct parameters . 
You can see the needed parameters with the command :
```
./install-collectd-monitor-1click.sh -h or ./install-collectd-client-1click.sh -h
```

If the installation is successfull, collectd is now running .
collectd is running like a service .

So if collectd will start automatically on boot .

#####Note
If you want to stop collectd, run the command :
```
sudo service collectd stop
```

If you want to start collectd, run the command :
```
sudo service collectd start
```

If you want to stop collectd, run the command :
```
sudo service collectd restart
```

Finally if for some weird reasons you want to remove collectd you just have to run the remove script according to your version of collectd
```
./remove-collectd-client.sh or ./remove-collectd-monitor.sh
```

Tada !
