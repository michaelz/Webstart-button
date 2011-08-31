#! /bin/bash

# used to start/stop services

NBAPACHE=`ps aux | grep apache | grep -v grep | wc -l `
NBMYSQL=`ps aux | grep mysql | grep -v grep | wc -l`
DIALOGTITLE="Webservices administration"

if [ $NBAPACHE -eq 0 ] ; then
	APACHESTATUS="stopped"
else
	APACHESTATUS="started"
fi

if [ $NBMYSQL -lt 2 ] ; then
	MYSQLSTATUS="stopped"
else
	MYSQLSTATUS="started"
fi

if [ $APACHESTATUS == "stopped" ] && [ $MYSQLSTATUS == "stopped" ] ; then
	TEXT="Both Apache2 and MySQL are stopped. Do you want to start them ?"
	VALUE="START_ALL"
	zenity --title "$DIALOGTITLE" --question --text "$TEXT"
elif [ $APACHESTATUS == "stopped" ] && [ $MYSQLSTATUS == "started" ] ; then
	TEXT="Apache2 is stopped, do you want to start it ?"
	VALUE="START_A"
	zenity --title "$DIALOGTITLE" --question --text "$TEXT"
elif [ $APACHESTATUS == "started" ] && [ $MYSQLSTATUS == "stopped" ] ; then
	TEXT="MySQL is stopped, do you want to start it ?"
	VALUE="START_M"
	zenity --title "$DIALOGTITLE" --question --text "$TEXT"
else
	TEXT="Stop MySQL and Apache2 servers ?"
	VALUE="STOP_ALL"
	zenity --title "$DIALOGTITLE" --question --text "$TEXT"
fi
RESPONSE=$?
if [ $RESPONSE -eq 0 ] && [ $VALUE == "START_ALL" ] ; then
	gksu /etc/init.d/apache2 start
	gksu /etc/init.d/mysql start
	zenity --info --text "Started : MYSQL APACHE2"

elif [ $RESPONSE -eq 0 ] && [ $VALUE == "START_A" ] ; then
	gksu /etc/init.d/apache2 start
	zenity --info --text "Started : APACHE2"
 
elif [ $RESPONSE -eq 0 ] && [ $VALUE == "START_M" ] ; then
	gksu /etc/init.d/mysql start
	zenity --info --text "Started : MYSQL"

elif [ $RESPONSE -eq 0 ] && [ $VALUE == "STOP_ALL" ] ; then
	gksu /etc/init.d/mysql stop 
	gksu /etc/init.d/apache2 stop
	zenity --info --text "Stopped : MYSQL APACHE2"
fi

