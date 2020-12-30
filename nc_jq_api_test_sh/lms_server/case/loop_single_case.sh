#!/bin/sh

#for line in `ls *.json` 
#do
#	echo "Line=$line"
#done

HOST=$1
LMS_SERVER_PORT=7780
LMS_STATION_PORT=7790
JSON_PATH=../json/
JSON_NAME=$2
LOOP_COUNT=$3


TARGET_JSON=$JSON_PATH/$JSON_NAME.json



run_target_json()
{
	echo "target json=$TARGET_JSON"
	cat $TARGET_JSON
	nc -v -w 8 $HOST $LMS_SERVER_PORT < $TARGET_JSON
}


echo "start loop LOOP_COUNT=$LOOP_COUNT"


myvar=1
while [ $myvar -le $LOOP_COUNT ]
do
	echo $myvar
	run_target_json
	myvar=$(( $myvar + 1 ))
done
