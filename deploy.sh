#!/bin/bash

CMDNAME=`basename $0`

usage_exit(){
	echo "Usage: $CMDNAME [-h hostname or ip address *NOT localhost*] [-n number of redis process] [-s masterserver if slave] ]" 1>&2
	exit 1
}
	
if [ 0 == $# ]; then
	usage_exit;
fi
while getopts h:n:s: OPT
do
  case $OPT in
    "h" ) FLG_H="TRUE" ; HOST="$OPTARG" ;;
    "n" ) FLG_N="TRUE" ; NUM="$OPTARG" ;;
    "s" ) IS_SLAVE="TRUE" ; MASTER="$OPTARG" ;;
      * ) usage_exit
          ;;
  esac
done

if [ $HOST eq 'localhost' ]; then
	usage_exit;
fi
export IS_SLAVE;
export HOST;
export NUM;
export MASTER;

./001_create_dir.sh
./002_create_conf.sh
./003_create_init.sh
./004_set_startup.sh
./101_nutcracker.sh
./201_create_sentinel_conf.sh 
./202_create_set_sentinel_startup.sh
