#README

By default jetty don't open the jmx connector.

To open it you have to choice :

  1. Go to your jetty folder and decomment the right part in etc/jetty-jmx.xml
  2. Run the configure-jetty.sh with the path to your jetty folder as parameter
  
```
./configure-jetty.sh path/to/jetty
```

Enjoy !
