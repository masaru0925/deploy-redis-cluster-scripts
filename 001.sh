#!/bin/bash

mkdir -p /var/local/run/redis
chown redis.redis /var/local/run/redis
chmod 750 /var/local/run/redis

for i in {1..$(($NUM+0))}
do
	echo $i
done
