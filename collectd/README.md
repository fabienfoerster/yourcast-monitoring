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
    
###Important

For a successful installation you will have to run the script install-collectd.sh as root .

The installation script require the path to your jdk 

```
./install-collectd.sh $JAVA_HOME
```

Also to monitor jetty7 with collectd you will have to configure jetty properly. For that matter please see the jetty folder .

After installation to run collectd execute the command :

```
/opt/collectd/sbin/collectd
```

#####Note : this installation run with jdk1.6.0_45


To be continued ....
  
