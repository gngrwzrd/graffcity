#!/bin/bash
PIDFILE="serve/fapws_${1}.pid"
PORT=${1}
sudo kill -9 `cat -- $PIDFILE` 2> /dev/null
sudo /usr/bin/python2.6 scripts/_fapwsd.py -p $PORT -i $PIDFILE
