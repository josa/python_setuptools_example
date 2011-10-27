#!/bin/sh

# chkconfig:   - 81 15 
# description:  FTP Videos R7

PROJECT_NAME="test"
PYTHON="/usr/bin/python2.7"
SCRIPT_PATH="/opt/"$PROJECT_NAME
PID_FILE="/var/run/"$PROJECT_NAME".pid"
CONFIG_FILE="/var/conf/"$PROJECT_NAME"/test.conf"
LOG_CONFIG_FILE="/var/logs/"$PROJECT_NAME"/logging.conf"

SHUTDOWN_WAIT=10
RETVAL="0"

case $1 in
start)
	if [ -f "$PID_FILE" ]; then
		echo -e "\nAtencao, "$PROJECT_NAME" ja iniciado usando PID $PID_FILE !!"
		ps www `cat $PID_FILE` 2> /dev/null
		echo 
		exit 2
	fi
	echo -n "Inicializando "$PROJECT_NAME"... "
	export PYTHONPATH=$SCRIPT_PATH
	$PYTHON $SCRIPT_PATH/com/example/Test.py $CONFIG_FILE $LOG_CONFIG_FILE $PID_FILE &
    ;;
stop)
	if [ ! -f "$PID_FILE" ]; then
	        echo "PID nao encontrado!"
	        exit 2
	fi
	PID=`cat $PID_FILE`
	RUNNING_APP=`ps -p $PID -o comm=`
	echo "Finalizando "$PROJECT_NAME"..."
	kill $PID  2> /dev/null
	if [ "$RETVAL" -eq "0" ]; then
	count="0"
	if [ -f "$PID_FILE" ]; then
	    until [ "$(ps --pid $PID | grep -c $PID)" -eq "0" ] || \
	            [ "$count" -gt "$SHUTDOWN_WAIT" ]; do
	            echo "esperando o processo $PID morrer ($count/$SHUTDOWN_WAIT)"
	            sleep 1
	            let count="${count}+1"
	        done
	        if [ "$count" -gt "$SHUTDOWN_WAIT" ]; then
	           echo "matando processo que nao morreu apos $SHUTDOWN_WAIT segundos"
	           kill -9 $PID
	        fi
	    fi
	    rm -f $PID_FILE
	fi
    ;;
status)
	if [ ! -f "$PID_FILE" ]; then
	        echo "PID nao encontrado!"
	   else
	        ps www `cat $PID_FILE` 2> /dev/nul
	fi
   ;;
*)
	echo "Usage: $0 (start|stop|status)"
	exit 1
    ;;
esac

