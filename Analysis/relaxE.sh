#!/usr/bin/env bash

if [ $# -eq 0 ]; then
	echo "ERROR: try 'sh relaxE.sh --help' for more information"
	exit
fi

while [ ! $# -eq 0 ]; do
  case "$1" in
    --help )
      echo "Usage: sh relaxE.sh [OPTION]...\n"
      exit
      ;;
    --input )
      DAT=$2
      DAT2=$3
      ;;
    --no-plot )
      PLOT=false
      ;;
    * )
      echo "ERROR: no matching options."
      exit
      ;;
    esac
  shift
done

PLOT="${PLOT:-true}"
DAT="${DAT:-$SCRATCH/Backup_Copper/DampE4}"
DAT2="${DAT2:-$SCRATCH/Backup_Copper/DampE3}"
#DAT2=$SCRATCH/Copper/
#DAT1=$SCRATCH/Backup_Copper/Ion1

if [ ${PLOT} = 'true' ]; then
gnuplot -persist <<-EOFMarker
  #set terminal postscript eps enhanced color
  #set terminal pdfcairo size 15cm,10cm enhanced color
  set terminal pngcairo  enhanced color
  
  #set output 'RelaxE.eps'
  set output 'RelaxE.png'

  set key top right
  #unset key
  
  #set encoding utf8 # Encoding for eps
  #set encoding iso_8859_1 # Encoding for pdf

  delta_v(x) = (vD=x-old_v,old_v=x,vD)
  old_v=NaN
  set logscale y
  set xlabel 'Step'
  set ylabel '\| log_{10} \|'
  set format y "10^{%L}"
  set ytics(1e-6,1e-5,1e-4,1e-3,1e-2,1e-1,1,1e1,1e2,1e3)
  set mytics 5
  set mxtics 10

  p '$DAT/cp.evp' u 1:(abs(delta_v(\$6)))  w l lw 2 lc 1 notitle,\
    '$DAT2/cp.evp' u 1:(abs(delta_v(\$6))) w l lw 2 lc 1 title "{/Symbol D}E_{DFT}",\
    '$DAT/cp.evp' u 1:(abs(\$3))  w l lw 2 lc 3 notitle,\
    '$DAT2/cp.evp' u 1:(abs(\$3)) w l lw 2 lc 3 title "E_{kinc}",\

EOFMarker
fi
