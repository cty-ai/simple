#!/bin/sh

echo $#
if [ $# -lt 3 ]; then
   echo "Usage:"
   echo "$0 [IP] [PORT] <loop>"
   exit 1
fi

IP=$1
PORT=$2
LOOP_TIMES=$3

TEMP_JSON=./json/temp.json
JSON_LMS_LIST=./json/lms_list.json
JSON_BOARD_CONFIG_SET=./json/ctlboard_config_set.json
JSON_BOARD_CONFIG_GET=./json/ctlboard_config_get.json
JSON_SLOT_LIST=./json/slot_list.json
JSON_SLOT_INFO_GET=./json/slot_info_get.json
JSON_SLOT_STAT_GET=./json/slot_state_get.json
JSON_MOUNT=./json/skp_mount.json
JSON_UNMOUNT=./json/skp_unmount.json
JSON_POWER_OFF=./json/slot_power_off.json
JSON_POWER_ON=./json/slot_power_on.json
JSON_CTLBOARD_INFO=./json/ctlboard_info_get.json
JSON_CTLBOARD_STATE=./json/ctlboard_state_get.json
JSON_PMBOARD_INFO=./json/pmboard_info_get.json
JSON_PMBOARD_STATE=./json/pmboard_state_get.json
JSON_PMBOARD_POWER_GET=./json/pmboard_power_get.json 

LOG=./log.txt
POWER_TEST=1
TIMES=0

var_param_api_array=(1 2 3 4 5 6)
var_param_api_array[0]=$JSON_CTLBOARD_INFO
var_param_api_array[1]=$JSON_CTLBOARD_STATE
var_param_api_array[2]=$JSON_PMBOARD_INFO
var_param_api_array[3]=$JSON_PMBOARD_STATE
var_param_api_array[4]=$JSON_PMBOARD_POWER_GET

fix_param_api_array=(1 2)
fix_param_api_array[0]=$JSON_SLOT_INFO_GET
fix_param_api_array[1]=$JSON_SLOT_STAT_GET

echo "Start test"

function run_var_param_api_test()
{
    API=$1
    echo "${API} SEND>>>"
    cat $API |jq .
    echo "${API} RECV<<<"
    nc -v $IP $PORT < $API | jq . > recv.json 
    cat recv.json | jq .
    #verify
    if [[ $(jq .code recv.json) -ne 0 ]]
    then
        echo "$(jq .code recv.json)"
        date
        echo "${API} error XXX"
        #save error log
        echo " " >> $LOG
        date >> $LOG
        echo "${API} error " >> $LOG
    fi
    echo "---------------------------------------------------------------------"
}

function run_fix_param_api_test()
{
    API=$1

    for (( COM=1; COM<=8; COM++ ))
    do
        for (( SLOT=1; SLOT<=1; SLOT++ ))
        do
            #run_fix_param_api_test
            echo "${API} SEND >>>"
            #replace lms sn
            #cp $JSON_UNMOUNT $TEMP_JSON
            #jq -r ".params.lms |= $LMS" $TEMP_JSON > $JSON_UNMOUNT
            #mv $JSON_UNMOUNT $TEMP_JSON
            #jq -r ".params.down |= 1" $TEMP_JSON > $JSON_UNMOUNT
            cp $API $TEMP_JSON
            jq -r ".params.com |= $COM" $API > $TEMP_JSON
            #jq -r ".params.slot |= $SLOT" $TEMP_JSON
            cat $TEMP_JSON | jq .
            echo "${API} RECV <<<"
            nc -v -w 5 $IP $PORT < $TEMP_JSON | jq . > recv.json
            cat recv.json | jq .

            #verify
            if [[ $(jq .code recv.json) -ne 0 ]]
            then
                echo "$(jq .code recv.json)"
                date
                echo "${API} error XXX"
                #save error log
                echo " " >> $LOG
                date >> $LOG
                echo "${API} error " >> $LOG
            fi
            echo "---------------------------------------------------------------------"
        done
    done
}


while [[ $LOOP_TIMES > 0 ]]
do
    let LOOP_TIMES--
    let TIMES++

    echo " " >> $LOG
    date >> $LOG
    echo "Running ... test times: $TIMES"
    echo "Running ... test times: $TIMES" >> $LOG
    
    for ((i=0;i<5;i++))
    do
        run_var_param_api_test ${var_param_api_array[$i]}
    done
    
    for ((i=0;i<2;i++))
    do
        run_fix_param_api_test ${fix_param_api_array[$i]}
    done
   
    echo " "
    echo " "
done
echo	"Done"