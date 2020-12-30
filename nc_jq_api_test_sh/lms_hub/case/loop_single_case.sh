#!/bin/sh

echo $#
if [ $# -le 2 ]; then
   echo "Usage:"
   echo "$0 <HOST> <loop> <json>"
   exit 1
fi

LMS_HUB_PORT=34593
HOST=$1
LOOP_COUNT=$2
JSON_FILE=$3

TARGET_JSON=$JSON_FILE

run_target_json()
{
	nc -w 8 $HOST $LMS_HUB_PORT < $TARGET_JSON
    echo ""
}

echo "target json=$TARGET_JSON"
echo "start loop LOOP_COUNT=$LOOP_COUNT"
cat $TARGET_JSON
echo ""

myvar=1
while [ $myvar -le $LOOP_COUNT ]
do
	echo $myvar
	run_target_json
	myvar=$(( $myvar + 1 ))
done
