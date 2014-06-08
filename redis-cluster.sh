#!/bin/bash


RETVAL=0
prog="redis-cluster"

start () {
	echo "Starting $prog ..."
	service nutcracker start
	for i in `ls /tmp/init`
	do
		service $i start
	done
	service redis-sentinel26379 start
    echo "Done."
}
stop () {
	echo "Stopping $prog ..."
	service redis-sentinel26379 stop
	service nutcracker stop
	for i in `ls /tmp/init`
	do
		service $i stop
	done
    echo "Done."
}

restart () {
    stop
    start
}

# See how we were called.
case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart|reload)
    restart
    ;;
  *)
    echo $"Usage: $0 {start|stop|restart|reload}"
    exit 1
esac

