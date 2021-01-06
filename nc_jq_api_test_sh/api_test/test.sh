#!/bin/bash

IP=$1
PORT=$2
TEMP_JSON=./json/temp.json
JSON1=./json/slot_reset.json
JSON2=./json/skp_mount.json
JSON3=./json/skp_unmount.json

LOG=./all_api_looooop_test_log.txt

POWER_TEST=1
LOOP_TIMES=3000
TIMES=0

echo "Start test"
COM=1
SLOT=1

all_port_test(){
    for ((COM=3;COM<=3;COM++ ));
    do
        for ((SLOT=8;SLOT<=12;SLOT++));
        do
            #unmount
            echo "SEND------>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
            cp $1 $TEMP_JSON
            jq -r ".params.com |= $COM" $TEMP_JSON > $1
            cp $1 $TEMP_JSON
            jq -r ".params.slot |= $SLOT" $TEMP_JSON > $1
            cat $1 | jq .
            echo "RECV------<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
            nc -v -w 5 $IP $PORT < $1 | jq . > recv.json
            cat recv.json | jq .
	        #verify
	        if [[ $(jq .code recv.json) -ne 0 ]]
	        then
		        echo "$(jq .code recv.json)"
		        date
		        echo "$COM $SLOT error XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
		        #save error log
	    	    echo " " >> $LOG			date >> $LOG
		        date >> $LOG
		        echo "$COM $SLOT error " >> $LOG
	        fi
            echo "---------------------------------------------------------------------"
            sleep 2
        done
    done
}

while [[ $LOOP_TIMES > 0 ]]
do

    let LOOP_TIMES--

    echo " " >> $LOG
    date >> $LOG
    TIMES=10000-$LOOP_TIMES
    echo "Running ..." >> $LOG
    echo " test times: $TIMES" >> $LOG

    all_port_test $JSON2
    all_port_test $JSON3

done

rm recv.json
echo "\nDone"

