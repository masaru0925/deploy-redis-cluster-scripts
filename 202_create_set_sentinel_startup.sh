#!/bin/sh

INIT_DIR=/etc/init.d

INIT1=redis-sentinel26379
#INIT2=redis-sentinel26380

rm -f $INIT_DIR/$INIT1
#rm -f $INIT_DIR/$INIT2
cp ./$INIT1 $INIT_DIR/.
#cp ./$INIT2 $INIT_DIR/.

chkconfig --add  $INIT1
#chkconfig --add  $INIT2

#chkconfig $INIT1 on
#chkconfig $INIT2 on
