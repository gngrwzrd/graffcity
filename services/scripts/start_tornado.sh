#!/bin/bash
PIDFILE="serve/tornado_${1}.pid"
PORT=${1}
sudo kill -9 `cat -- $PIDFILE` 2> /dev/null
sudo /usr/bin/python2.6 scripts/_tornadod.py -p $PORT -i $PIDFILE
