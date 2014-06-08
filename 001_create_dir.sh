#!/bin/bash

mkdir -p /var/local/run/redis
chown redis.redis /var/local/run/redis
chmod 750 /var/local/run/redis

for i in `seq 1 $NUM`
do
    mkdir -p /var/local/lib/redis$i/
    chown redis.redis /var/local/lib/redis$i
    chmod 750 /var/local/lib/redis$i

    mkdir -p /var/local/log/redis$i/
    chown redis.redis /var/local/log/redis$i
    chmod 750 /var/local/log/redis$i
done
