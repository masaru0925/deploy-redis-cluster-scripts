#!/bin/sh

INIT_DIR=/etc/init.d
for i in `seq 1 $NUM`
do
	chkconfig --del  redis$i
	chkconfig --add  redis$i
#	chkconfig redis$i on
done
