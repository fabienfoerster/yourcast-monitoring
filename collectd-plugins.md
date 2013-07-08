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
