#!/bin/bash

FAILOVER_PL=/opt/ActivePerl-5.18/site/bin/failover.pl
# -----------------------------------------------------
PORT=26379
LOG_DIR=/var/local/log/sentinel$PORT
PID_FILE=/var/local/run/redis/sentinel$PORT.pid
CONF_FILE=/etc/redis/sentinel$PORT.conf

mkdir -p $LOG_DIR
chown redis.redis $LOG_DIR

rm -f $CONF_FILE
echo "port $PORT" >$CONF_FILE
echo "daemonize yes" >>$CONF_FILE
echo "logfile \"$LOG_DIR/sentinel.log\"" >>$CONF_FILE
echo "pidfile \"$PID_FILE\"" >>$CONF_FILE

for i in `seq 1 $NUM`; do
    REDIS_PORT=`echo $(($i+6379))`
	if [ $IS_SLAVE ]; then
		echo "sentinel monitor redis_$i $MASTER $REDIS_PORT 3" >>$CONF_FILE
	else
		echo "sentinel monitor redis_$i $HOST $REDIS_PORT 3" >>$CONF_FILE
	fi
	echo "sentinel down-after-milliseconds redis_$i 10000" >>$CONF_FILE
	echo "sentinel parallel-syncs redis_$i 1" >>$CONF_FILE
	echo "sentinel failover-timeout redis_$i 180000" >>$CONF_FILE
	echo "sentinel client-reconfig-script redis_$i $FAILOVER_PL" >>$CONF_FILE
	echo "" >>$CONF_FILE
done
chown redis.redis $CONF_FILE


# -----------------------------------------------------
PORT2=26380
LOG_DIR=/var/local/log/sentinel$PORT
PID_FILE=/var/local/run/redis/sentinel$PORT.pid
CONF_FILE=/etc/redis/sentinel$PORT.conf

mkdir -p $LOG_DIR
chown redis.redis $LOG_DIR

rm -f $CONF_FILE
echo "port $PORT" >$CONF_FILE
echo "daemonize yes" >>$CONF_FILE
echo "logfile \"$LOG_DIR/sentinel.log\"" >>$CONF_FILE
echo "pidfile \"$PID_FILE\"" >>$CONF_FILE

for i in `seq 1 $NUM`; do
    REDIS_PORT=`echo $(($i+6379))`
	if [ $IS_SLAVE ]; then
		echo "sentinel monitor redis_$i $MASTER $REDIS_PORT 3" >>$CONF_FILE
	else
		echo "sentinel monitor redis_$i $HOST $REDIS_PORT 3" >>$CONF_FILE
	fi
	echo "sentinel down-after-milliseconds redis_$i 10000" >>$CONF_FILE
	echo "sentinel parallel-syncs redis_$i 1" >>$CONF_FILE
	echo "sentinel failover-timeout redis_$i 180000" >>$CONF_FILE
	echo "sentinel client-reconfig-script redis_$i $FAILOVER_PL" >>$CONF_FILE
	echo "" >>$CONF_FILE
done
chown redis.redis $CONF_FILE



