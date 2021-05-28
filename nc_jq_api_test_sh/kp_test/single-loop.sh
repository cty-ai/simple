#!/bin/bash
DISK_SN_STR=\"661612246000\"
TAX_SN_STR=\"440300L73007804\"
DISK_TYPE_STR=\"JSP\"
INVOICE_TYPE=\"026\"

MAIN_JSON_FILE=./json/00-main.json
#API_JSON_FILE=./json/1-打开金税卡.json
TMP_JSON_FILE=./json/tmp.json
URL='https://iot.honekit.com/oapi/device/port-relay/P100/34599/P10080FA5B26C176'

if [ $# -ne 2 ]
then
    echo "single-loop.sh [api-num] [loop_times]"
    echo "api num:"
    ls ./json/*
    exit
fi

# get api json
API_JSON_FILE=$(ls ./json/* | grep $1)

# get loop times
LOOP_TIMES=$2
echo $API_JSON_FILE $LOOP_TIMES

# child json---------------------------------------------
# '.kpzdbs'=DISK_SN_STR
if [[ $(cat $API_JSON_FILE | jq '.content | has("kpzdbs")') = true ]]
then
    TMP_JSON_STR=$(jq ".content.kpzdbs = $DISK_SN_STR" $API_JSON_FILE)
    echo $TMP_JSON_STR | jq . > $API_JSON_FILE
fi
# '.nsrsbh'=TAX_SN_STR
if [[ $(cat $API_JSON_FILE | jq '.content | has("nsrsbh")') = true ]]
then
    TMP_JSON_STR=$(jq ".content.nsrsbh = $TAX_SN_STR" $API_JSON_FILE)
    echo $TMP_JSON_STR | jq . > $API_JSON_FILE
fi
# '.fplxdm'=INVOICE_TYPE
if [[ $(cat $API_JSON_FILE | jq '.content | has("fplxdm")') = true ]]
then
    TMP_JSON_STR=$(jq ".content.fplxdm = $INVOICE_TYPE" $API_JSON_FILE)
    echo $TMP_JSON_STR | jq . > $API_JSON_FILE
fi
# api base64 encode
ENCODE_STR=$(base64 -w 0 $API_JSON_FILE)
#echo $ENCODE_STR
# child json---------------------------------------------

# main json--------------------------------------------
#cat $MAIN_JSON_FILE | jq .
TMP_JSON_STR=$(cat $MAIN_JSON_FILE | jq .)

# '.biz' = businessCode
BIZ_STR=$(jq ".businessCode" $API_JSON_FILE)
#echo $BIZ_STR
echo $TMP_JSON_STR > $TMP_JSON_FILE
TMP_JSON_STR=$(jq ".biz = $BIZ_STR" $TMP_JSON_FILE)

# '.taxno' = $TAX_SN_STR
echo $TMP_JSON_STR > $TMP_JSON_FILE
TMP_JSON_STR=$(jq ".taxno = $TAX_SN_STR" $TMP_JSON_FILE)

# '.did' =$DISK_SN_STR
echo $TMP_JSON_STR > $TMP_JSON_FILE
TMP_JSON_STR=$(jq ".did = $DISK_SN_STR" $TMP_JSON_FILE)

# '.dtype' =$DISK_TYPE_STR
echo $TMP_JSON_STR > $TMP_JSON_FILE
TMP_JSON_STR=$(jq ".dtype = $DISK_TYPE_STR" $TMP_JSON_FILE)

# '.data' = encode data
echo $TMP_JSON_STR > $TMP_JSON_FILE
TMP_JSON_STR=$(jq ".data = \"$ENCODE_STR\"" $TMP_JSON_FILE)
echo $TMP_JSON_STR | jq .
# main json--------------------------------------------

while [ $LOOP_TIMES -gt 0 ]
do
    # http put
    RET_STR=$(curl -s -H "Content-Type:application/json" -X PUT -d "$TMP_JSON_STR" $URL)
    echo $RET_STR | jq .
    echo $RET_STR > $TMP_JSON_FILE
    RET_CODE=$(jq ".code" $TMP_JSON_FILE)
    #echo $RET_CODE
    if [ $RET_CODE -ne 0 ]
    then
        echo "$API_JSON_FILE TEST ERROR"
        exit
    fi

    let "LOOP_TIMES--"
    echo $LOOP_TIMES
done
