#!/usr/bin/env bash

if [ $# -eq 0 ]; then
  echo "ERROR: try 'sh forces.sh --help' for more information"
  exit
fi

while [ $# -eq 0 ]; do
  case "$1" in
    --help )
      exit
      ;;
    --input )
      INPUT1=$2
      INPUT2=$3
      ;;
    --output )
      OUTPUT1=$2
      OUTPUT2=$3
      ;;
    --no-plot )
      PLOT=false
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

INPUT1="${INPUT1:-cu_ion_relax1.o}"
INPUT2="${INPUT2:-cu_ion_relax1.o}"
OUTPUT1="${OUTPUT1:-FORCES1.dat}"
OUTPUT2="${OUTPUT2:-FORCES2.dat}"
PLOT="${PLOT:-true}"

if [ -f ${INPUT1} ]; then
  echo "ERROR: The 1st file '${INPUT1}' not found."
  exit 1
fi

if [ ! -f ${INPUT2} ]; then
  echo "ERROR: The 2d file '${INPUT2}' not found."
  exit 1
fi

# EXAMPLE
#INPUT1='../Output/cu_gram-schmidth.o'
#INPUT1='../Output/cu_edamping4.o'
#INPUT2='../cu_ion_relax1.o'
#OUTPUT1='FORCES1.dat'
#OUTPUT2='FORCES2.dat'

#=============
# Main Script
#=============

NAT=`grep 'atoms =' $INPUT1 | awk '{print $5}'`

function GetForces {
  FORCES=(`awk -v "NAT=${NAT}" '/Forces/{for (i=1;i<=NAT;i++){getline;print sqrt($2*$2+$3*$3+$4*$4);}}' $1`)
  RADIUS=(`awk -v "NAT=${NAT}" '/ATOMIC_POSITIONS/{for (i=1;i<=NAT;i++){getline;print sqrt($2*$2+$3*$3+$4*$4);}}' $1`)

  rm -f FORCES.dat
  for i in `seq 0 $(($NAT-1))`; do
    printf '%s\t%s\n' ${RADIUS[$i]} ${FORCES[$i]} >> forces.dat
  done

  sort --general-numeric-sort -t" " -k1 forces.dat > $2
  rm forces.dat
}

GetForces $INPUT1 $OUTPUT1
GetForces $INPUT2 $OUTPUT2

if [ ${PLOT} = 'true' ]; then
gnuplot -persist <<-EOFMarker
  #set terminal postscript eps enhanced color
  #set terminal pdfcairo size 15cm,10cm enhanced color
  set terminal pngcairo  enhanced color
  
  #set output 'sigma2.pdf'
  set output 'Forces.png'

  set key top right
  #unset key

  #set encoding utf8 # Encoding for eps
  #set encoding iso_8859_1 # Encoding for pdf

  set xlabel 'Radius'
  set ylabel 'Force'
  set logscale y
  set format y "10^{%L}"
  set mytics 5
  set mxtics 10

  p '$OUTPUT1' u 1:2  w lp lw 2 lc 2 title "Initial wf",\
    '$OUTPUT2' u 1:2  w lp lw 2 lc 3 title "Relaxed wf"

EOFMarker
fi
rm $OUTPUT1
rm $OUTPUT2
