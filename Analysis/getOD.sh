#!/bin/bash

# Get the optimal damping factor

INPUT=$SCRATCH/Backup_Copper/DampE1/cp.evp

ETOT=(`tail --lines=3 $INPUT | awk '{print $6}'`)
E1=${ETOT[0]}
E2=${ETOT[1]}
E3=${ETOT[2]}
RESULT=`awk -v e1="$E1" -v e2="$E2" -v e3="$E3" 'BEGIN{
 theta=log((e1-e2)/(e2-e3))/log(10); 
 if (theta < 0) {
 	print "ERROR";
 } else {
 	print sqrt(0.5*theta);
 }
}'`


if [ $RESULT = "ERROR" ]; then
	echo "ERROR: IMAGINARY SOLUTION"
else
	echo $RESULT
fi
