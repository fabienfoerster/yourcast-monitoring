# Collectd Readme for a wonderful installation

This README is writting for the version 5.3.0 of collectd but it should work for the later version.

You can check the latest version here [collectd.org](https://collectd.org/download.shtml).


## Getting the daemon


First if you don't you should install the *build-essential* package to be sure you have the usual C-compiler, linker, and so on.

```
apt-get install build-essential
```

The daemon itself doesn't depend on any libraries, but the plugins that collect the actual values will. What libraries are needed for which plugins is documented in the [Table of Plugins](https://collectd.org/wiki/index.php/Table_of_Plugins) file. Install the necessary libraries:

```
apt-get install librrd2-dev libsensors-dev libsnmp-dev ...
```

**Warning** : if you want to install some new plugins after your first installation, you may have to rebuild the whole program.

After installing the build dependencies, you need to get and unpack the sources:

```
cd /tmp/
wget http://collectd.org/files/collectd-x.y.z.tar.bz2
tar jxf collectd-x.y.z.tar.bz2
cd collectd-x.y.z
```

Now configure the sources with the usual:

```
./configure
```

After the configure script is done it will display a summary of the libraries it has found (and not found) and which plugins are enabled. Per default, all plugins whose dependencies are met are enabled. If a plugin you want to use is missing, install the required development package and run configure again.

Last but not least: Compile and install the program. Per default it will be installed to /opt/collectd.

```
make all install
```


For mongoDB plugin :

sudo ln -sf /usr/local/lib/libmongoc.so.0.7 /lib64/

sudo ln -sf /usr/local/lib/libbson.so.0.7 /lib64/


