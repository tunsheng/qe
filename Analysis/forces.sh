#!/bin/bash
PLOT=true
#INPUT1='../Output/cu_gram-schmidth.o'
INPUT1='../Output/cu_edamping4.o'
INPUT2='../cu_ion_relax1.o'
OUTPUT1='FORCES1.dat'
OUTPUT2='FORCES2.dat'

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
