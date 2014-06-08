#!/bin/bash


service nutcracker stop
chkconfig --del nutcracker
rm -rf /etc/init.d/nutcrucker

for i in `ls /tmp/init`
do
	service $i stop
	chkconfig --del $i
	rm -rf /etc/init.d/$i
done

service redis-sentinel26379 stop
service redis-sentinel26380 stop
chkconfig --del redis-sentinel26379 
chkconfig --del redis-sentinel26380 
rm -rf /etc/init.d/redis-sentinel26379
rm -rf /etc/init.d/redis-sentinel26380
