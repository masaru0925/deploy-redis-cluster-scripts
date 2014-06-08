#!/bin/bash

FAILOVER_PL=/opt/ActivePerl-5.18/site/bin/failover.pl
# -----------------------------------------------------
PORT1=26379
LOG_DIR1=/var/local/log/sentinel$PORT1 
PID_FILE1=/var/local/run/redis/sentinel$PORT1.pid
CONF_FILE1=/etc/redis/sentinel$PORT1.conf

mkdir -p $LOG_DIR1
chown redis.redis $LOG_DIR1

rm -f $CONF_FILE1
echo "port $PORT1" >$CONF_FILE1
echo "daemonize yes" >>$CONF_FILE1
echo "logfile \"$LOG_DIR1/sentinel.log\"" >>$CONF_FILE1
echo "pidfile \"$PID_FILE1\"" >>$CONF_FILE1

for i in `seq 1 $NUM`; do
    REDIS_PORT=`echo $(($i+6379))`
	if [ $IS_SLAVE ]; then
		echo "sentinel monitor redis_$i $MASTER $REDIS_PORT 2" >>$CONF_FILE1
	else
		echo "sentinel monitor redis_$i $HOST $REDIS_PORT 2" >>$CONF_FILE1
	fi
	echo "sentinel down-after-milliseconds redis_$i 10000" >>$CONF_FILE1
	echo "sentinel parallel-syncs redis_$i 1" >>$CONF_FILE1
	echo "sentinel failover-timeout redis_$i 180000" >>$CONF_FILE1
	echo "sentinel client-reconfig-script redis_$i $FAILOVER_PL" >>$CONF_FILE1
	echo "" >>$CONF_FILE1
done
chown redis.redis $CONF_FILE1


# -----------------------------------------------------
PORT2=26380
LOG_DIR2=/var/local/log/sentinel$PORT2 
PID_FILE2=/var/local/run/redis/sentinel$PORT2.pid
CONF_FILE2=/etc/redis/sentinel$PORT2.conf

mkdir -p $LOG_DIR2
chown redis.redis $LOG_DIR2

rm -f $CONF_FILE2
echo "port $PORT2" >$CONF_FILE2
echo "daemonize yes" >>$CONF_FILE2
echo "logfile \"$LOG_DIR2/sentinel.log\"" >>$CONF_FILE2
echo "pidfile \"$PID_FILE2\"" >>$CONF_FILE2

for i in `seq 1 $NUM`; do
    REDIS_PORT=`echo $(($i+6379))`
	if [ $IS_SLAVE ]; then
		echo "sentinel monitor redis_$i $MASTER $REDIS_PORT 3" >>$CONF_FILE2
	else
		echo "sentinel monitor redis_$i $HOST $REDIS_PORT 3" >>$CONF_FILE2
	fi
	echo "sentinel down-after-milliseconds redis_$i 10000" >>$CONF_FILE2
	echo "sentinel parallel-syncs redis_$i 1" >>$CONF_FILE2
	echo "sentinel failover-timeout redis_$i 180000" >>$CONF_FILE2
	echo "sentinel client-reconfig-script redis_$i $FAILOVER_PL" >>$CONF_FILE2
	echo "" >>$CONF_FILE2
done
chown redis.redis $CONF_FILE2
