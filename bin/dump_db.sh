#!/bin/bash

PROG="$(basename $0)"
CUR_DIR="$(pwd)"

cd $(dirname $0)
BIN_DIR="$(pwd)"

cd ..
TOP_DIR="$(pwd)"
LOG_DIR="$TOP_DIR/log"
DATA_DIR="$TOP_DIR/data"
ETC_DIR="$TOP_DIR/etc"

LOG="$LOG_DIR/dump_db.log"
DMP_DIR=$(date +"$DATA_DIR/mongo_dump_%Y%m%d%H%M%S")
DMP_TBZ="${DMP_DIR}.tbz"

cd "${CUR_DIR}"

#
umask 0

## dump database
date +"==== %c: BEGIN dump database" | tee -a $LOG

mongodump -o $DMP_DIR 2>&1 | tee -a $LOG
tar cjfv "$DMP_TBZ" -C "$(dirname $DMP_DIR)" "$(basename $DMP_DIR)" 2>&1 | tee -a $LOG
rm -rf $DMP_DIR 2>&1 | tee -a $LOG

date +"---- %c:  END  dump database" | tee -a $LOG

# EOF
