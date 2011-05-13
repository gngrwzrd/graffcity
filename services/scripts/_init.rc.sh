#!/bin/bash
#
#       /etc/rc.d/init.d/
#
#
#
#
#

#Init script to startup app server
#http://www.linux.com/archive/feed/46892
#make sure to add this to chkconfig for startup

. /etc/init.d/functions

APP="All City"
APP_DIR=/var/www/nginx/vhosts/app.allcity.com/
TORNADO=tornado
FAPWS=fapws

start() {
	echo -n "Starting : ${APP}"
	cd $APP_DIR
	./scripts/raise_${TORNADO}.sh
	./scripts/raise_${FAPWS}.sh
	return
}

stop() {
	echo -n "Shutting down : ${APP}"
	cd $APP_DIR
	./scripts/bury_${TORNADO}.sh
	./scripts/bury_${FAPWS}.sh
	return
}

case "$1" in
	start)
		start
		;;
	stop)
		stop
		;;
	restart)
		stop
		start
		;;
	*)
		echo "Usage: {start|stop}"
		exit 1
		;;
esac
exit $?