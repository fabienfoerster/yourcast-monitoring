#Probe

Exhaustive list of the collectd probe using in monitoring yourcast 


###CPU

```
cpu.average..user       #CPU time spent by normal programs and daemons
cpu.average..system     #CPU time spent by the kernel in system activities
cpu.average..idle       #Idle CPU time
cpu.average..wait       #CPU time spent waiting for I/O operations to finish when there is nothing else to do.
cpu.average..interrupt 
cpu.average..softirq    #CPU time spent handling "batched" interrupts
cpu.average..steal      #The time that a virtual CPU had runnable tasks, but the virtual CPU itself was not running
cpu.average..nice       #CPU time spent by nice programs
```

###Memory

```
memory...used 
memory...free 
memory...buffered
memory...cached
```

###JMX
```
GenericJMX.memory_pool..committed
GenericJMX.memory_pool..init
GenericJMX.memory_pool..max
GenericJMX.memory_pool..used
GenericJMX.memory-heap..committed
GenericJMX.memory-heap..init
GenericJMX.memory-heap..max
GenericJMX.memory-heap..used
GenericJMX.memory-nonheap..committed
GenericJMX.memory-nonheap..init
GenericJMX.memory-nonheap..max
GenericJMX.memory-nonheap..used 
GenericJMX.gc.invocations.
GenericJMX.gc.total_time_in_ms.    
GenericJMX.loaded_classes..     #Number of classes loaded by the JVM
```

###Interface

RX = Receive Buffer
TX = Transmit Buffer

###Mongo
```
mongo.27017..query
mongo.27017..delete
mongo.27017..update
mongo.27017..insert
mongo.27017-{{collection}}..object_count #Number of objects in the collection
# change {{collection}} with the collection you want to monitor
```
