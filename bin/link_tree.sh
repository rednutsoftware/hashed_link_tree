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

LINK_TREE_CMD="$BIN_DIR/link_tree.py"
LINK_TREE_LOG="$LOG_DIR/link_tree.log"

cd "${CUR_DIR}"

#
PROFILE=/etc/profile.d/python3.bash
if [ -f $PROFILE ]
then
    . $PROFILE
fi

if [ $# -lt 2 ]
then
    echo "usage: $PROG <FILE_BASE_DIR> <LINK_BASE_DIR> [<LIMIT>]"
    exit
fi

#
umask 0

## link files
FILE_BASE_DIR="$1"
LINK_BASE_DIR="$2"
LIMIT="${3:-0}"

date +"==== %c: BEGIN make link tree" | tee -a $LINK_TREE_LOG

$LINK_TREE_CMD "$FILE_BASE_DIR" "$LINK_BASE_DIR" "$LIMIT" 2>&1 | tee -a $MK_DB_LOG

date +"---- %c:  END  make link tree" | tee -a $LINK_TREE_LOG

# EOF
