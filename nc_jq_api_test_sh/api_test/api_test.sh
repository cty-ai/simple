#!/bin/sh

IP=$1
PORT=$2
TEMP_JSON=./json/temp.json
JSON_LMS_LIST=./json/lms_list.json
JSON_BOARD_CONFIG_SET=./json/ctlboard_config_set.json
JSON_BOARD_CONFIG_GET=./json/ctlboard_config_get.json
JSON_SLOT_LIST=./json/slot_list.json
JSON_MOUNT=./json/skp_mount.json
JSON_UNMOUNT=./json/skp_unmount.json
JSON_POWER_OFF=./json/slot_power_off.json
JSON_POWER_ON=./json/slot_power_on.json

LOG=./all_api_looooop_test_log.txt

POWER_TEST=1
LOOP_TIMES=10000
TIMES=0

echo "Start test"

while [[ $LOOP_TIMES > 0 ]]
do

let LOOP_TIMES--

echo " " >> $LOG
date >> $LOG
TIMES=10000-$LOOP_TIMES
echo "Running ..." >> $LOG
echo " test times: $TIMES" >> $LOG

#get lms list
echo "get lms list SEND------>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
cat $JSON_LMS_LIST |jq .
echo "get lms list RECV------<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
nc -v $1 $2 < $JSON_LMS_LIST | jq . > recv.json
cat recv.json | jq .
#verify
if [[ $(jq .code recv.json) -ne 0 ]]
then
	echo "$(jq .code recv.json)"
	date
	echo "lms list api error XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
	#save error log
	echo " " >> $LOG
	date >> $LOG
	echo "lms list api error " >> $LOG
fi
echo "---------------------------------------------------------------------"

#get lms sn
LMS=$(jq .result[0].jsbh recv.json)
echo $LMS

#board config set
echo "board config set SEND------>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
#replace lms sn
cp $JSON_BOARD_CONFIG_SET $TEMP_JSON
jq -r ".params.lms |= $LMS" $TEMP_JSON > $JSON_BOARD_CONFIG_SET
cat $JSON_BOARD_CONFIG_SET |jq .
echo "board config set RECV------<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
nc -v $1 $2 < $JSON_BOARD_CONFIG_SET | jq . > recv.json
cat recv.json | jq .
#verify
if [[ $(jq .code recv.json) -ne 0 ]]
then
	echo "$(jq .code recv.json)"
	date
	echo "board config set api error XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
	#save error log
	echo " " >> $LOG
	date >> $LOG
	echo "board config set api error " >> $LOG
fi
echo "---------------------------------------------------------------------"

#board config get
echo "board config get SEND------>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
#replace lms sn
cp $JSON_BOARD_CONFIG_GET $TEMP_JSON
jq -r ".params.lms |= $LMS" $TEMP_JSON > $JSON_BOARD_CONFIG_GET
cat $JSON_BOARD_CONFIG_GET |jq .
echo "board config get RECV------<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
nc -v $1 $2 < $JSON_BOARD_CONFIG_GET | jq . > recv.json
cat recv.json | jq .
#verify
if [[ $(jq .code recv.json) -ne 0 ]]
then
        echo "$(jq .code recv.json)"
        date
        echo "board config get api error XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
        #save error log
        echo " " >> $LOG
        date >> $LOG
        echo "board config get api error " >> $LOG
fi
echo "---------------------------------------------------------------------"

#get slot list
echo "get slot list SEND------>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
#replace lms sn
cp $JSON_SLOT_LIST $TEMP_JSON
jq -r ".params.lms |= $LMS" $TEMP_JSON > $JSON_SLOT_LIST
cat $JSON_SLOT_LIST | jq .
echo "get slot list RECV------<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
nc -v $1 $2 < $JSON_SLOT_LIST | jq . > recv.json
cat recv.json | jq .
#verify
if [[ $(jq .code recv.json) -ne 0 ]]
then
	echo "$(jq .code recv.json)"
	date
	echo "get slot list api error XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
	#save error log
	echo " " >> $LOG
	date >> $LOG
	echo "get slot list api error " >> $LOG
fi
echo "---------------------------------------------------------------------"

for (( COM=2; COM<=2; COM++ ))
do
    for (( SLOT=1; SLOT<=1; SLOT++ ))
    do
        #unmount
        echo "unmount SEND------>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        #replace lms sn
        cp $JSON_UNMOUNT $TEMP_JSON
        jq -r ".params.lms |= $LMS" $TEMP_JSON > $JSON_UNMOUNT
        #mv $JSON_UNMOUNT $TEMP_JSON
        #jq -r ".params.down |= 1" $TEMP_JSON > $JSON_UNMOUNT
        cp $JSON_UNMOUNT $TEMP_JSON
        jq -r ".params.com |= $COM" $TEMP_JSON > $JSON_UNMOUNT
        cp $JSON_UNMOUNT $TEMP_JSON
        jq -r ".params.slot |= $SLOT" $TEMP_JSON > $JSON_UNMOUNT
        cat $JSON_UNMOUNT | jq .
        echo "unmount RECV------<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
        nc -v -w 5 $1 $2 < $JSON_UNMOUNT | jq . > recv.json
        cat recv.json | jq .
	#verify
	if [[ $(jq .code recv.json) -ne 0 ]]
	then
		echo "$(jq .code recv.json)"
		date
		echo "$COM $SLOT unmount api error XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
		#save error log
		echo " " >> $LOG			date >> $LOG
		date >> $LOG
		echo "$COM $SLOT unmount api error " >> $LOG
	fi
        echo "---------------------------------------------------------------------"
        sleep 1
    done
    
    for (( SLOT=1; SLOT<=1; SLOT++ ))
    do
        #mount
        echo "mount SEND------>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        #replace lms sn
        cp $JSON_MOUNT $TEMP_JSON
        jq -r ".params.lms |= $LMS" $TEMP_JSON > $JSON_MOUNT
        cp $JSON_MOUNT $TEMP_JSON
        jq -r ".params.com |= $COM" $TEMP_JSON > $JSON_MOUNT
        cp $JSON_MOUNT $TEMP_JSON
        jq -r ".params.slot |= $SLOT" $TEMP_JSON > $JSON_MOUNT
        cat $JSON_MOUNT | jq .
        echo "mount RECV------<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
        nc -v -w 5 $1 $2 < $JSON_MOUNT | jq . > recv.json
        cat recv.json | jq .
        #verify
        if [[ $(jq .code recv.json) -ne 0 ]]
        then
                echo "$(jq .code recv.json)"
                date
                echo "$COM $SLOT mount api error XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
                #save error log
                echo " " >> $LOG                        date >> $LOG
                date >> $LOG
                echo "$COM $SLOT mount api error " >> $LOG
        fi
	echo "---------------------------------------------------------------------"
        sleep 1
    done

    for (( SLOT=1; SLOT<=1; SLOT++ ))
    do
        #unmount
        echo "unmount SEND------>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        #replace lms sn
        cp $JSON_UNMOUNT $TEMP_JSON
        jq -r ".params.lms |= $LMS" $TEMP_JSON > $JSON_UNMOUNT
        #cp $JSON_UNMOUNT $TEMP_JSON
        #jq -r ".params.down |= 1" $TEMP_JSON > $JSON_UNMOUNT
        cp $JSON_UNMOUNT $TEMP_JSON
        jq -r ".params.com |= $COM" $TEMP_JSON > $JSON_UNMOUNT
        cp $JSON_UNMOUNT $TEMP_JSON
        jq -r ".params.slot |= $SLOT" $TEMP_JSON > $JSON_UNMOUNT
        cat $JSON_UNMOUNT | jq .
        echo "unmount RECV------<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
        nc -v -w 5 $1 $2 < $JSON_UNMOUNT | jq . > recv.json
        cat recv.json | jq .
	#verify
        if [[ $(jq .code recv.json) -ne 0 ]]
        then
                echo "$(jq .code recv.json)"
                date
                echo "$COM $SLOT unmount api error XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
                #save error log
                echo " " >> $LOG                        date >> $LOG
                date >> $LOG
                echo "$COM $SLOT unmount api error " >> $LOG
        fi

        echo "---------------------------------------------------------------------"
        sleep 1
    done

if (( $POWER_TEST ))
then
    for (( SLOT=1; SLOT<=1; SLOT++ ))
    do
        #power off
        echo "power off SEND------>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        #replace lms sn
        cp $JSON_POWER_OFF $TEMP_JSON
        jq -r ".params.lms |= $LMS" $TEMP_JSON > $JSON_POWER_OFF
        cp $JSON_POWER_OFF $TEMP_JSON
        jq -r ".params.com |= $COM" $TEMP_JSON > $JSON_POWER_OFF
        cp $JSON_POWER_OFF $TEMP_JSON
        jq -r ".params.slot |= $SLOT" $TEMP_JSON > $JSON_POWER_OFF
        cat $JSON_POWER_OFF | jq .
        echo "power off RECV------<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
        nc -v $1 $2 < $JSON_POWER_OFF | jq . > recv.json
        cat recv.json | jq .
	#verify
        if [[ $(jq .code recv.json) -ne 0 ]]
        then
                echo "$(jq .code recv.json)"
                date
                echo "$COM $SLOT power off api error XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
                #save error log
                echo " " >> $LOG                        date >> $LOG
                date >> $LOG
                echo "$COM $SLOT power off api error " >> $LOG
        fi

        echo "---------------------------------------------------------------------"
    done

    for (( SLOT=1; SLOT<=1; SLOT++ ))
    do
        #power on
        echo "power on SEND------>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        #replace lms sn
        cp $JSON_POWER_ON $TEMP_JSON
        jq -r ".params.lms |= $LMS" $TEMP_JSON > $JSON_POWER_ON
        cp $JSON_POWER_ON $TEMP_JSON
        jq -r ".params.com |= $COM" $TEMP_JSON > $JSON_POWER_ON
        cp $JSON_POWER_ON $TEMP_JSON
        jq -r ".params.slot |= $SLOT" $TEMP_JSON > $JSON_POWER_ON
        cat $JSON_POWER_ON | jq .
        echo "power on RECV------<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
        nc -v $1 $2 < $JSON_POWER_ON | jq . > recv.json
        cat recv.json | jq .
	#verify
        if [[ $(jq .code recv.json) -ne 0 ]]
        then
                echo "$(jq .code recv.json)"
                date
                echo "$COM $SLOT power on api error XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
                #save error log
                echo " " >> $LOG                        date >> $LOG
                date >> $LOG
                echo "$COM $SLOT power on api error " >> $LOG
        fi

        echo "---------------------------------------------------------------------"
    done
fi
done

done
rm recv.json
echo	"\nDone"

