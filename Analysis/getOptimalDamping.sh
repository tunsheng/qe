#!/usr/bin/env bash

#=============
# Description
#=============
# Compute the optimal damping factor for cp.x

if [ $# -eq 0 ]; then
  echo "ERROR: try 'sh getOptimalDamping.sh --help' for more information"
  exit
fi

while [ $# -eq 0 ]; do
  case "$1" in
    --help )
      exit
      ;;
    --input )
      $INPUT=$2
      ;;
    --default )
      ;;
    * )
      echo "ERROR: No matching option."
      exit
      ;;
    esac
    shift
done
INPUT="${INPUT:-$SCRATCH/Backup_Copper/DampE1/cp.evp}"

if [ ! -f ${INPUT} ]; then
  echo "ERROR: The file '${INPUT}' not found."
  exit 1
fi


#=============
# Main Script
#=============
ETOT=(`tail --lines=3 $INPUT | awk '{print $6}'`)
E1=${ETOT[0]}
E2=${ETOT[1]}
E3=${ETOT[2]}
RESULT=`awk -v e1="$E1" -v e2="$E2" -v e3="$E3" 'BEGIN{
 theta=log((e1-e2)/(e2-e3))/log(10); 
 if (theta < 0) {
 	print "ERROR";
 } else {
 	print "Optimal damping =", sqrt(0.5*theta);
 }
}'`

if [ "${RESULT}" = "ERROR" ]; then
	echo "ERROR: IMAGINARY SOLUTION"
else
	echo ${RESULT}
fi
