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

CHECK_TREE_CMD="$BIN_DIR/check_tree.py"
CHECK_TREE_LOG="$LOG_DIR/check_tree.log"

cd "${CUR_DIR}"

#
PROFILE=/etc/profile.d/python3.bash
if [ -f $PROFILE ]
then
    . $PROFILE
fi

if [ $# -lt 1 ]
then
    echo "usage: $PROG <LINK_BASE_DIR> [<LIMIT>]"
    exit
fi

#
umask 0

## check files
LINK_BASE_DIR="$1"
LIMIT="${2:-0}"

date +"==== %c: BEGIN check link tree" | tee -a $CHECK_TREE_LOG

$CHECK_TREE_CMD "$LINK_BASE_DIR" "$LIMIT" 2>&1 | tee -a $CHECK_TREE_LOG

date +"---- %c:  END  check link tree" | tee -a $CHECK_TREE_LOG

# EOF
