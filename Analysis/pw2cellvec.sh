#!/usr/bin/env bash
# Bash version of Julen Larrucea's pw2cellvec https://larrucea.eu/src/pw2cellvec
export LANG=en_US.UTF-8

#===================
#   Flags
#===================
if [ -z ${INPUT} ]; then
  echo "pw2cellvec: Requires an input file."
  exit 1
fi

while [ $# -eq 0 ]
do
  case "$1" in
    --help | -h)
      printf '%s\n' "Requires input file from vc-relax of pw.x calculation." | fold -s
      printf "Usage: sh pw2cellvec.sh [OPTION]...\n"
      printf "\t --debug\n"
      printf "\t\t\t Run in debug mode"
      printf "\t --position\n"
      printf "\t\t\t Print atomic positions"
      exit
      ;;
    --position )
      PRINT_POSITION=true
      ;;
    --debug )
      DEBUG=true
    esac
    shift
done

PRINT_POSITION="${PRINT_POSITION:-false}"
DEBUG="${DEBUG:-false}"

#===================
#   Math functions
#===================
# Define Bohr constant and Pi
PI=3.1415926535897932384
AU=0.5291772083
INPUT=$1

function length() {
 local DUMMY=''
 local A=`echo $DUMMY |
    awk -v a="$1" -v b="$2" -v c="$3"\
        '//{print sqrt(a**2 + b**2 + c**2)}'`
 echo $A
}

function angle() {
 local DUMMY=''
 local VX=$1
 local VY=$2
 local VZ=$3
 local UX=$4
 local UY=$5
 local UZ=$6
 local V2=`length ${VX} ${VY} ${VZ}`
 local U2=`length ${UX} ${UY} ${UZ}`
 local ALPHA=`echo $DUMMY |
 awk -v a="${VX}" -v b="${VY}" -v c="${VZ}" \
    -v d="${UX}" -v e="${UY}" -v f="${UZ}" \
    -v s="${V2}" -v t="${U2}" -v pi="${PI}" \
    'function acos(x) { return atan2(sqrt(1-x*x),x); }
     //{ ratio=((a*d+b*e+c*f)/(s*t)); print ratio }'
 `
 export ALPHA
 export PI
 local ALPHA=`perl -E 'use Math::Trig; say acos($ENV{ALPHA})*180/$ENV{PI}'`
 echo ${ALPHA}
}

#===================
#   MAIN SCRIPT
#===================
VOL_AU=(`awk '/new unit-cell volume/{print $5 }' $INPUT`)
VOL_AA=(`awk '/new unit-cell volume/{print $8 }' $INPUT`)
ALAT=(`awk '/CELL_PARAMETERS/{print $3 }' $INPUT | sed 's/)//g'`)
NOPT=${#ALAT[@]}
CELL=(`awk '/CELL_PARAMETERS/{
  for (i=1;i<=3;i++) {
     getline;
     a1=$1;
     print $0, '\n';
  }
}' $INPUT`)

POS=(`awk '/ATOMIC_POSITIONS/{
  for (i=1;i<=1;i++) {
     getline;
     print $0, '\n';
  }
}' $INPUT`)

# Check
if [ -z ${CELL} ]; then
  echo "ERROR: No cell parameter found."
  exit 1
fi

if [ -z ${POS} ]; then
  echo "ERROR: No atomic position found."
  exit 1
fi

declare -A LATTICEV
for i in `seq 0 $(( ${NOPT} - 1 ))`; do
  LATTICELENGTH=()
  for j in `seq 0 2`; do
    if [ ${DEBUG} = 'true' ]; then
      printf "%s\t%s\t%s\n" ${CELL[$p]} ${CELL[$q]} ${CELL[$r]}
    fi
    p=$(($i*9+3*$j))
    q=$(($i*9+3*${j}+1))
    r=$(($i*9+3*${j}+2))
    LATTICELENGTH+=(`length ${CELL[${p}]} ${CELL[${q}]} ${CELL[${r}]}`)
    LATTICEV[$j,0]=${CELL[${p}]}
    LATTICEV[$j,1]=${CELL[${q}]}
    LATTICEV[$j,2]=${CELL[${r}]}
  done
  V1=(${LATTICEV[0,0]} ${LATTICEV[0,1]} ${LATTICEV[0,2]})
  V2=(${LATTICEV[1,0]} ${LATTICEV[1,1]} ${LATTICEV[1,2]})
  V3=(${LATTICEV[2,0]} ${LATTICEV[2,1]} ${LATTICEV[2,2]})
  a=${LATTICELENGTH[0]}
  b=${LATTICELENGTH[1]}
  c=${LATTICELENGTH[2]}
  alpha=`angle ${V1[@]} ${V2[@]}`
  beta=`angle ${V1[@]} ${V3[@]}`
  gamma=`angle ${V2[@]} ${V3[@]}`

  DUMMY=''
  A1=`echo ${DUMMY} | awk -v a="${a}" -v au="${AU}" -v alat="${ALAT[$i]}" '//{print a*au*alat}'`
  B1=`echo ${DUMMY} | awk -v a="${b}" -v au="${AU}" -v alat="${ALAT[$i]}" '//{print a*au*alat}'`
  C1=`echo ${DUMMY} | awk -v a="${c}" -v au="${AU}" -v alat="${ALAT[$i]}" '//{print a*au*alat}'`
  A2=`echo ${DUMMY} | awk -v a="${a}" -v au="${AU}" '//{print a*au}'`
  B2=`echo ${DUMMY} | awk -v a="${b}" -v au="${AU}" '//{print a*au}'`
  C2=`echo ${DUMMY} | awk -v a="${c}" -v au="${AU}" '//{print a*au}'`
  CA=`echo ${DUMMY} | awk -v a="${a}" -v c="${c}" '//{print c/a}'`
  echo "--STRUCTURE for iter $(( ${i}+1 ))--"
  printf 'Alat=%s angstrom\n' ${ALAT[$i]}
  printf 'AA a=%s,\t b=%s,\t c=%s,\t vol=%s\n' "${A1}" "${B1}" "${C1}" "${VOL_AA[$i]}"
  printf 'au a=%s,\t b=%s,\t c=%s,\t c/a=%s\n' "${A2}" "${B2}" "${C2}" "${CA}"
  printf '   alpha=%s\xc2\xb0,\t beta=%s\xc2\xb0,\t gamma=%s\xc2\xb0\n' "${alpha}" "${beta}" "${gamma}"
  echo '--END--'
  echo
done

echo "Final lattice vectors (angstrom)"
k=$(( ${NOPT} - 1 ))
for j in `seq 0 2`; do
  A1=`echo ${DUMMY} | awk -v a="${CELL[${k}*9+3*${j}]}" -v au="${AU}" -v alat="${ALAT[$i]}" '//{print a*au*alat}'`
  B1=`echo ${DUMMY} | awk -v a="${CELL[${k}*9+3*${j}+1]}" -v au="${AU}" -v alat="${ALAT[$i]}" '//{print a*au*alat}'`
  C1=`echo ${DUMMY} | awk -v a="${CELL[${k}*9+3*${j}+2]}" -v au="${AU}" -v alat="${ALAT[$i]}" '//{print a*au*alat}'`
  printf "\t%f\t %f\t %f\n" ${A1} ${B1} ${C1}
done
echo

if [ ${PRINT_POSITION} = 'true' ]; then
  for i in `seq 0 $(( ${NOPT} - 1 ))`; do
    echo "Atomic Positions for iter ${i}"
    for j in `seq 0 0`; do
      printf "%s\t%s\t%s\n" ${POS[${i}*9+3*${j}]} ${POS[${i}*9+3*${j}+1]} ${POS[${i}*9+3*${j}+2]}
    done
  done
fi
