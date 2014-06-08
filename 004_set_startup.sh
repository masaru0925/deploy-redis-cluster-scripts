#!/bin/sh

for i in `seq 1 $NUM`
do
#	chkconfig --del  redis$i
	echo "chkconfig --add  redis$i"
	chkconfig --add  redis$i
#	chkconfig redis$i on
done
