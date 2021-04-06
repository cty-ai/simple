#!/bin/bash

IP=$1
PORT=$2
TEMP_JSON=./json/temp.json
JSON1=./json/slot_reset.json
JSON2=./json/skp_mount.json
JSON3=./json/skp_unmount.json
JSON4=./json/slot_power_on.json
JSON5=./json/slot_power_off.json

LOG=./all_api_looooop_test_log.txt

POWER_TEST=1
LOOP_TIMES=3000
TIMES=0
SLEEP=0

echo "Start test"
COM=4
SLOT=1

ARRAY=(1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7)

all_port_test(){
    for ((COM=4;COM<=4;COM++ ));
    do
        for ((SLOT=1;SLOT<=9;SLOT++));
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
        done
    done
}

loop_port_test(){
    for ((COM=4;COM<=4;COM++ ));
    do
        for ((SLOT=1;SLOT<=9;SLOT++));
        do
            #unmount
            echo "SEND------>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
            cp $2 $TEMP_JSON
            jq -r ".params.com |= $COM" $TEMP_JSON > $2
            cp $2 $TEMP_JSON
            jq -r ".params.slot |= $SLOT" $TEMP_JSON > $2
            cat $2 | jq .
            echo "RECV------<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
            nc -v -w 5 $IP $PORT < $2 | jq . > recv.json
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
            RAND=`expr $LOOP_TIMES - $SLOT`
            RAND=`expr $RAND % 10`
            echo "$RAND ${ARRAY[$RAND]}" 
            sleep ${ARRAY[$RAND]}
            #unmount
            echo "SEND------>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
            cp $2 $TEMP_JSON
            jq -r ".params.com |= $COM" $TEMP_JSON > $2
            cp $2 $TEMP_JSON
            jq -r ".params.slot |= $SLOT" $TEMP_JSON > $2
            cat $2 | jq .
            echo "RECV------<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
            nc -v -w 5 $IP $PORT < $2 | jq . > recv.json
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
        leep 4
        done
    done
}


while [[ $LOOP_TIMES > 0 ]]
do

    let LOOP_TIMES--

    echo " " >> $LOG
    date >> $LOG
    TIMES=3000-$LOOP_TIMES
    echo "Running ..." >> $LOG
    echo " test times: $TIMES" >> $LOG
    SLEEP=0.01*$TIMES
#    all_port_test $JSON4
#    sleep 0.05
#    all_port_test $JSON5
#    sleep 2
    loop_port_test $JSON4 $JSON5
done

rm recv.json
echo "\nDone"

