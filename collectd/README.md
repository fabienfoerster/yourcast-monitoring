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
After installation to run collectd execute the command :

```
/opt/collectd/sbin/collectd
```

To be continued ....
  
