#!/bin/bash

CONF_DEST_DIR=/etc/redis/conf
ORG_DIR=/usr/local/redis
CONF_TMP_DIR=/tmp/conf
rm -rf $CONF_TMP_DIR
mkdir $CONF_TMP_DIR
rm -rf $CONF_DEST_DIR
mkdir -p $CONF_DEST_DIR
rm -f $CONF_DEST_DIR/redis*.conf
for i in `seq 1 $NUM`
do
    #give each instance another port
    #PORT=`echo $i+6379|bc`
    PORT=`echo $(($i+6379))`
    #create a new config file for each instance
    cp  $ORG_DIR/6379.conf $CONF_TMP_DIR/redis$i.conf
    # this is just a search and replace instruction
    perl -p -i -e 's|^pidfile .*$|pidfile "/var/local/run/redis/redis'$i'.pid"|g' $CONF_TMP_DIR/redis$i.conf
    perl -p -i -e 's|^port .*$|port '$PORT'|g' $CONF_TMP_DIR/redis$i.conf
    perl -p -i -e 's|^logfile .*$|logfile "/var/local/log/redis'$i'/redis.log"|g' $CONF_TMP_DIR/redis$i.conf
    perl -p -i -e 's|^dir .*$|dir "/var/local/lib/redis'$i'"|g' $CONF_TMP_DIR/redis$i.conf
    #chmod 750 $CONF_TMP_DIR/redis$i.conf

	if [ $IS_SLAVE ]; then
		echo "slaveof $MASTER $PORT" >> $CONF_TMP_DIR/redis$i.conf
	fi
	cp $CONF_TMP_DIR/redis$i.conf $CONF_DEST_DIR/.
	chown redis.redis $CONF_DEST_DIR/redis$i.conf
done
