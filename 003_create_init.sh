#!/bin/bash

INIT_DEST_DIR=/etc/init.d
CONF_DEST_DIR=/etc/redis/conf
INIT_TMP_DIR=/tmp/init
PID_DIR=/var/local/run/redis
ORG_DIR=/usr/local/redis
USER=redis

rm -rf $INIT_TMP_DIR
rm -f $INIT_DEST_DIR/redis*
mkdir $INIT_TMP_DIR
for i in `seq 1 $NUM`
do
    #give each instance another port
    #PORT=`echo $i+6379|bc`
    PORT=$(($i+6379))
    #create a new config file for each instance
    cp  $ORG_DIR/utils/redis_init_script $INIT_TMP_DIR/redis$i
    # this is just a search and replace instruction
    perl -p -i -e 's|# processname: redis|# processname: redis\n. /etc/rc.d/init.d/functions\n|g' $INIT_TMP_DIR/redis$i
    perl -p -i -e 's|REDISPORT=6379|REDISPORT='$PORT'|g' $INIT_TMP_DIR/redis$i
    perl -p -i -e 's|EXEC=.*$|EXEC="daemon --user '$USER' /usr/local/bin/redis-server"|g' $INIT_TMP_DIR/redis$i
    perl -p -i -e 's|CLIEXEC=.*$|CLIEXEC="daemon --user '$USER' /usr/local/bin/redis-cli"|g' $INIT_TMP_DIR/redis$i

    perl -p -i -e 's|PIDFILE=.*$|PIDFILE="'$PID_DIR'/redis'$i'.pid"|g' $INIT_TMP_DIR/redis$i
    perl -p -i -e 's|CONF=.*$|CONF="'$CONF_DEST_DIR'/redis'$i'.conf"|g' $INIT_TMP_DIR/redis$i
    chmod 750 $INIT_TMP_DIR/redis$i
	cp $INIT_TMP_DIR/redis$i $INIT_DEST_DIR/.
done
