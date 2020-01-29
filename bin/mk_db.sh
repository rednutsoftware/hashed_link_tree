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

MK_DB_CMD="$BIN_DIR/mk_db.py"
MK_DB_LOG="$LOG_DIR/mk_db.log"

cd "${CUR_DIR}"

#
PROFILE=/etc/profile.d/python3.bash
if [ -f $PROFILE ]
then
    . $PROFILE
fi

if [ $# -lt 2 ]
then
    echo "usage: $PROG <HASH_BASE_DIR> <HASH_DIR1> [<HASH_DIR2> ...]"
    exit
fi

#
umask 0

## make database
HASH_BASE_DIR=$1
shift

date +"==== %c" | tee -a $MK_DB_LOG

for d in $*
do
    echo "making database for $HASH_BASE_DIR/$d" | tee -a $MK_DB_LOG
    $MK_DB_CMD $HASH_BASE_DIR $d | tee -a $MK_DB_LOG 2>&1
    date | tee -a $MK_DB_LOG
done

echo "----" | tee -a $MK_DB_LOG

# EOF
