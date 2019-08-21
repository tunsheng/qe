#!/bin/bash

###########################################
# Validate required inputs
# for quantum espresso pw.x and cp.x input
#
# Saves time before running into errors
#
# Usage:
#       sh validate.sh xxx.in || exit 1
###########################################

keywords=(
ibrav
nat
ntyp
ecutwfc
)

INPUT=`echo $1 | awk '{$1=$1};1'`
length=${#keywords[@]}

for i in `seq 0 $(($length-1))`; do
 EXIST=`grep -o ${keywords[$i]} ${INPUT}`
 
 if [ -z ${EXIST} ]; then
  echo "ERROR: Keyword '${keywords[$i]}' is missing."
  exit 1
 fi 
done
