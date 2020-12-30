#!/bin/sh

JSON_DIR=./json
if [ -n ${TEST_HOST} ]; then
  HOST=${TEST_HOST}
fi

if [ -n ${TEST_PORT} ]; then
  PORT=${TEST_PORT}
fi

echo $#
if [ $# -eq 2 ]; then
  LOOP_COUNT=$1
  JSON_LIST_FILE=$2
elif [ $# -eq 4 ]; then
  PORT=$1
  HOST=$2
  LOOP_COUNT=$3
  JSON_LIST_FILE=$4
else
   echo "Usage:"
   echo "$0 [port] [host] <loop> <json-list>"
   exit 1
fi

TEST_PASSED=0
TEST_FAILED=0

function run_test_case()
{
  fn=$1
  jqf=$2
  exp=$3
  lgf=$4
  resp=`nc -w 8 ${HOST} ${PORT} < ${fn}`
  ret=`echo ${resp} | jq -c -j ${jqf}`
  if [ "x${ret}" = "x${exp}" ]; then
    TEST_PASSED=$(($TEST_PASSED + 1))
    echo "PASSED: ${ret}" >> ${lgf} 
  else
    TEST_FAILED=$(($TEST_FAILED + 1))
    echo "FAILED: |${exp}|${ret}|" >> ${lgf}
    echo "${resp}" >> ${lgf}
  fi
}

function loop_test_case()
{
    count=$1
    jsonfile=$2
    jqex=$3
    expect=$4
    slp=0
    if [ $# -gt 4 ]; then
      slp=$5
    fi
    CASE_TESTED=$(($CASE_TESTED + 1))
    rtime=1
    TEST_PASSED=0
    TEST_FAILED=0
    #echo "=========================>>"
    fname=`basename ${jsonfile}`
    logfile="${LOG_DIR}/${fname}.log"
    rm -f ${logfile}
    printf "%3d ${fname}:\n" ${CASE_TESTED}
    while [ ${rtime} -le $count ]
    do
        printf "\rTested:%4d, Passed:%4d, Failed:%4d" ${rtime} ${TEST_PASSED} ${TEST_FAILED}
        run_test_case ${jsonfile} ${jqex} ${expect} ${logfile}
        printf "\rTested:%4d, Passed:%4d, Failed:%4d" ${rtime} ${TEST_PASSED} ${TEST_FAILED}
        rtime=$(($rtime + 1))
        if [ ${slp} -gt 0 ]; then
          sleep ${slp}
        fi
    done
    rtime=$(($rtime - 1))
    printf "\n"
    #passed=`grep 'PASSED:' ${logfile} | wc -l`
    #failed=`grep 'FAILED:' ${logfile} | wc -l`
    #printf ", Passed: %d${passed}, Failed: ${failed}\n"
    #echo "<<========================="
    echo "${fname},${rtime},${TEST_PASSED},${TEST_FAILED}" >> ${TEST_RESULT_CSV}
}

echo "Start loop test"
echo "host: ${HOST} port: ${PORT} loop: ${LOOP_COUNT}"
LOG_DIR=log/${HOST}_${PORT}
mkdir -p ${LOG_DIR}

tvar=`basename ${JSON_LIST_FILE}`
TEST_RESULT_CSV=${LOG_DIR}/${tvar}.csv
rm -rf ${TEST_RESULT_CSV}

CASE_TESTED=0
while IFS= read -r line
do
  #echo ${line} >> response.list
  #nc -w 8 ${HOST} ${PORT} < ${line} >> response.list
  #echo " " >> response.list
  #continue
  if [ -z "${line}" ]; then
    continue
  fi
  if [ "x$(expr substr "${line}" 1 1)" == 'x#' ]; then
    continue
  fi
  OLD_IFS="$IFS"
  IFS="#"
  params=(${line})
  #echo "params ${params[0]} ${params[1]} ${params[2]} ${params[3]}"
  json="${JSON_DIR}/${params[0]}"
  loop_test_case ${LOOP_COUNT} ${json} ${params[1]} ${params[2]} ${params[3]}
  IFS=${OLD_IFS}
done < "${JSON_LIST_FILE}"

echo "End loop test"
