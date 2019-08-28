#!/bin/bash
PLOT=true
#INPUT1='../Output/cu_gram-schmidth.o'
INPUT1=$SCRATCH/Backup_Copper/Ion1/cp.for
INPUT2='../cu_ion_relax1.o'
OUTPUT1='FORCES1.dat'
OUTPUT2='FORCES2.dat'

NAT=`grep 'atoms =' $INPUT2 | awk '{print $5}'`
NATP=$(( ${NAT} + 1 ))
FIRSTLINE=`head --lines=1 ${INPUT1}`
LASTLINE=`tail --lines=${NATP} ${INPUT1} | head --lines=1`
N1=`echo ${FIRSTLINE} | awk '{print $1}'`
N2=`echo ${LASTLINE} | awk '{print $1}'`
echo "From "${N1}" to "${N2}

#TRAJECTORY=( `awk -v NAT="${NAT}" -v pp="${FIRSTLINE}" -v ll="${LASTLINE}" '$0~pp {
# iter=$1;
# tforce=$2;
#  for (i=1;i<=1;i++) {
#	 getline;
#	 print sqrt($2*$2+$3*$3+$4*$4);
#  }
#}' ${INPUT1}` )

#echo ${TRAJECTORY[@]}

#function GetForces {
#  FORCES=(`awk -v "NAT=${NAT}" '/Forces/{for (i=1;i<=NAT;i++){getline;print sqrt($2*$2+$3*$3+$4*$4);}}' $1`)
#  RADIUS=(`awk -v "NAT=${NAT}" '/ATOMIC_POSITIONS/{for (i=1;i<=NAT;i++){getline;print sqrt($2*$2+$3*$3+$4*$4);}}' $1`)

#  rm -f FORCES.dat
#  for i in `seq 0 $(($NAT-1))`; do
#    printf '%s\t%s\n' ${RADIUS[$i]} ${FORCES[$i]} >> forces.dat
#  done
#
#  sort --general-numeric-sort -t" " -k1 forces.dat > $2
#  rm forces.dat
#}

#GetForces $INPUT1 $OUTPUT1
#GetForces $INPUT2 $OUTPUT2

