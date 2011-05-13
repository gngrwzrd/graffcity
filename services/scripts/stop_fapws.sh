#!/bin/bash
PIDFILE="serve/fapws_${1}.pid"
sudo kill -9 `cat -- $PIDFILE` 2> /dev/null