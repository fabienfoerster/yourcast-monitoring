# Collectd Installation Instructions

This README is writting for the version 5.3.0 of collectd but it should work for the later version.

You can check the latest version here [collectd.org](https://collectd.org/download.shtml).


## Getting the daemon


First if you should install the *build-essential* package to be sure you have the usual C-compiler, linker, and so on.

```
sudo apt-get install build-essential
```

The daemon itself doesn't depend on any libraries, but the plugins that collect or write the actual values will. What libraries are needed for which plugins is documented in the [Table of Plugins](https://collectd.org/wiki/index.php/Table_of_Plugins) file. 

##Install the necessary libraries:

The next section will show you how install the necessary libraries for the **write_http** and the **write_mongodb** plugin.

##write_http

For this plugin you will have to install the following libraries

```
sudo apt-get install libcurl4-gnutls-dev librtmp-dev 
```

##write_mongodb

For this plugin you will have to install the lib mongoc .
Go to [https://github.com/mongodb/mongo-c-driver](https://github.com/mongodb/mongo-c-driver) and clone the repository :

```
git clone https://github.com/mongodb/mongo-c-driver.git libmongoc
```
The following instructions are for the version v.0.7.1. If a new stable version is available change the instructions accordingly or check the [official documentation](http://api.mongodb.org/c/current/).

**Important :** Always build from a particular tag, since HEAD may be work in progress .

```
git checkout v0.7.1
```
If you're building the driver on posix-compliant platforms, including on OS X and Linux, then you can build with make.
Else check the [official documentation](http://api.mongodb.org/c/current/).

To compile the driver, run:
```
make
```
Then you can install the librairies with make as root:
```
sudo make install
```

Finally execute this command as root to correct some weir bug : 
*( change lib64 for lib if you are on a 32Bits machine)*
```
sudo ln -sf /usr/local/lib/libmongoc.so.0.7 /lib64/
sudo ln -sf /usr/local/lib/libbson.so.0.7 /lib64/
```

**Warning** : if you want to install some new plugins after your first installation, you may have to rebuild the whole program.

##Compiling the sources

After installing the build dependencies, you need to get and unpack the sources:

```
cd /tmp/
wget http://collectd.org/files/collectd-5.3.0.tar.bz2
tar jxf collectd-5.3.0.tar.bz2
cd collectd-5.3.0
```

To configure the sources and enable java plugins run the following command :

```
./configure --with-java="path/to/your/jdk"
```

After the configure script is done it will display a summary of the libraries it has found (and not found) and which plugins are enabled. Per default, all plugins whose dependencies are met are enabled. If a plugin you want to use is missing, install the required development package and run configure again.

Last but not least: Compile and install the program. Per default it will be installed to /opt/collectd.

```
sudo make all install
```

## Configuration

The configuration will lie in /opt/collectd/etc/collectd.conf It's manual page is [collectd.conf(5)](http://collectd.org/documentation/manpages/collectd.conf.5.shtml). Open the file and pay particular attention to the LoadPlugin lines.

```
vim etc/collectd.conf
```
###Loading plugins

When you built, the configure script tries hard to provide you with a small, working default configuration. The configuration can usually be found in *etc/collectd.conf*

For each plugin, there is a LoadPlugin line in the configuration. Almost all of those lines are commented out in order to keep the default configuration lean. However, the number of comment characters used is significant:

* Lines commented out with two hash characters ("##") belong to plugins that have not been built. Commenting these lines in will result in an error, because the plugin does not exist.
* The LoadPlugin lines commented out using one hash character ("#") belong to plugins that have been built. You can comment them in / out as you wish.
* By default the following plugins are enabled: CPU, Interface, Load, and Memory.

By default exactly one write plugin is enabled. The first plugin available will be taken in this order: RRDtool, Network, CSV.

Likewise only one log plugin is enabled. If available, the SysLog plugin will be enabled, otherwise the LogFile plugin is used.

Please see the binary package's documentation to find out which other plugins are included and can be enabled. There's a wiki page containing a [table of all plugins](https://collectd.org/wiki/index.php/Table_of_Plugins).

###Setting options

The interval setting controls how often values are read. You should set this once and then never touch it again. If you do, **you will have to delete all your RDD files** or know some serious RDDtool magic!


##Starting the daemon

Since the default location is */opt/collectd* . To start the daemon you would have to execute :

```
/opt/collectd/sbin/collectd
```

Some plugins require root privileges to work properly. If you're missing graphs and/or see error messages that indicate insufficient permissions, restart collectd as root.

The daemon should now collect values using the "input" plugins you've loaded and write them to files using the "output" plugin(s). Any problems or interesting behavior is reported using the "log" plugin(s).

Tada !
