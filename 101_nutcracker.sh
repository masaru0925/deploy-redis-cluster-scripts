#!/bin/bash
CONF_DEST_P_DIR=/etc/nutcracker
CONF_DEST_DIR=$CONF_DEST_P_DIR/conf
INIT_DEST_DIR=/etc/init.d
CONF_FILE=./nutcracker_rediscluster.yml 
rm -rf $CONF_DEST_DIR
mkdir -p $CONF_DEST_DIR

rm -f $CONF_FILE

echo "redis_cluster:" >$CONF_FILE
echo "  auto_eject_hosts: false" >>$CONF_FILE
echo "  distribution: ketama" >>$CONF_FILE
echo "  hash: fnv1a_64" >>$CONF_FILE
echo "  listen: 0.0.0.0:6379" >>$CONF_FILE
echo "  preconnect: true" >>$CONF_FILE
echo "  redis: true" >>$CONF_FILE
echo "  servers:" >>$CONF_FILE

for i in `seq 1 $NUM`; do
    REDIS_PORT=`echo $(($i+6379))`
	if [ $IS_SLAVE ]; then
	    echo "    - $MASTER:$REDIS_PORT:1 redis_$i" >>$CONF_FILE
	else
		echo "    - $HOST:$REDIS_PORT:1 redis_$i" >>$CONF_FILE
	fi
done

cp $CONF_FILE $CONF_DEST_DIR/.


chown -R redis.redis $CONF_DEST_P_DIR

cp ./nutcracker $INIT_DEST_DIR/.
chkconfig --del nutcracker
chkconfig --add nutcracker
chkconfig nutcracker on
