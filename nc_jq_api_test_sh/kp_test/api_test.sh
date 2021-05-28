#!/bin/bash

DISK_SN_STR=\"661612246000\"
TAX_SN_STR=\"440300L73007804\"
DISK_TYPE_STR=\"JSP\"

MAIN_JSON_FILE=./json/0-main.json
API_JSON_FILE=./json/1-打开金税卡.json
TMP_JSON_FILE=./json/tmp.json
URL='https://iot.honekit.com/oapi/device/port-relay/P100/34599/P10080FA5B26C176'

# api base64 encode
ENCODE_STR=$(base64 -w 0 $API_JSON_FILE)

#echo $ENCODE_STR
#cat $MAIN_JSON_FILE | jq .
TMP_JSON_STR=$(cat $MAIN_JSON_FILE | jq .)

# '.biz' = businessCode
BIZ_STR=$(jq ".businessCode" $API_JSON_FILE)
echo $BIZ_STR
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

# http put
curl -H "Content-Type:application/json" -X PUT -d "$TMP_JSON_STR" $URL

