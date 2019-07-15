#####################################
# Quantum Espresso Input Generator  #
#                                   #
#    This is a skeleton script for  #
#    automating runs. Add your own  #
#    for-loops, arrays etc to suit  #
#    your applications.             #
#                                   #
#####################################
# Runs:
#  1 - wavefunction optimization
#  2 - s.d. wavefunction optimization
#  3 - propagate wavefunction
#  4 - structural optimization
#  5 - MD run
RUNS=2

#################
# COMMON INPUTS #
#################

# CONTROL
TITLE='Copper'
CALCULATION='cp'
OUTDIR='./tmp'
PSEUDODIR='/global/homes/t/tunsheng/QE/pseudo/'
TSTRESS='.FALSE.'    # Default: false
TPRNFOR='.TRUE.'    # Default: true
VERBOSITY='medium'
EKINCONVTHR='NULL'
ETOTCONVTHR='NULL'
FORCCONVTHR='NULL'
NSTEP=1             # Default: 1
TIMESTEP=NULL       # Default: 20.d0
NDR=50
NDW=50
IPRINT=2
ISAVE=10
PREFIX=NULL         # Prefix for filenames

# SYSTEM
IBRAV=0    # Bravais-lattice index
NAT=216      # Number of atoms in unit cell
NTYP=1     # Number of types of atoms in unit cell
ECUTWFC=35.0
NBND='NULL'     # Number of electronics states/bands

# ELECTRONS
ELECTRONDYNAMICS='NULL'
ELECTRONVELOCITY='NULL'
ELECTRONDAMPING=NULL
EMASS=NULL
EMCUTOFF=NULL
AMPRE=NULL
STARTINGWFC='NULL'
ORTHOMAX=NULL
ORTHOGONALIZATION='NULL'

# IONS
IONDYNAMICS='NULL'
IONVELOCITY='NULL'
IONDAMPING=NULL
TEMPW=NULL
FNOSEP=NULL

#ERANGE='0.01 0.012 0.014 0.016 0.018 0.02 0.022 0.024'
ERANGE='0.02'
for EDAMP in $ERANGE
do
if [ $RUNS -eq 1 ];
then #  1 - start with gram-schmidt
  MODE='from_scratch'
  TITLE='Copper: Minimizing wavefunction [1 / 3 steps]'
  ISAVE=1
  IPRINT=1
  NDR=50
  NDW=50
  TIMESTEP=5.0d0
  NSTEP=10
  ELECTRONDYNAMICS='sd'
  EMASS=700.0
  EMCUTOFF=3.0
  AMPRE=0.01
  STARTINGWFC='random'
  ORTHOGONALIZATION='Gram-Schmidt'
  IONDYNAMICS='none'
elif [ $RUNS -eq 2 ];
then #  2 - restart with orthogonal method
  MODE='restart'
  TITLE='Copper: Minimizing wavefunction [2 / 3 steps]'
  ISAVE=10
  IPRINT=1
  NSTEP=100
  NDR=50
  NDW=51
  TIMESTEP=10.0d0
  #ETOTCONVTHR='1.e-7'
  ELECTRONDYNAMICS='sd'
  EMASS=1000.0
  EMCUTOFF=3.0
  ORTHOMAX=300
  IONDYNAMICS='none'
elif [ $RUNS -eq 3 ];
then # 3 - propagate ground state wavefunction
  MODE='restart'
  TITLE='Copper: Minimizing wavefunction [3 / 3 steps]'
  ISAVE=10
  IPRINT=1
  NSTEP=100
  TIMESTEP=5.d0
  NDR=51
  NDW=52
  #ETOTCONVTHR='1.e-7'
  ELECTRONDYNAMICS='damp'
  ELECTRONDAMPING=0.2
  EMASS=1000.0
  EMCUTOFF=3.0
  ORTHOMAX=300
  IONDYNAMICS='none'
elif [ $RUNS -eq 4 ];
then #  4 - structural optimization
  MODE='restart'
  TITLE='Copper: Minimizing geometry [1 / 3 steps]'
  NDR=54
  NDW=60
  IPRINT=1
  ISAVE=10
  TIMESTEP=1.0d0
  NSTEP=200
  EKINCONVTHR='1.e-5'
  ETOTCONVTHR='1.e-7'
  FORCCONVTHR='1.e-5'
  ELECTRONDYNAMICS='damp'
  ELECTRONVELOCITY='zero'
  ELECTRONDAMPING=0.001
  EMASS=500.0
  EMCUTOFF=3.0
  ORTHOMAX=300
  IONDYNAMICS='damp'
  IONVELOCITY='zero'
  IONDAMPING=0.02
elif [ $RUNS -eq 5 ];
then #  5 - MD run
  MODE='reset_counters'
  TITLE='Copper: MD'
  NSTEP=100
  IPRINT=1
  ISAVE=10
  TIMESTEP=8.0d0
  NDR=60
  NDW=70
  ELECTRONDYNAMICS='verlet'
  EMASS=500.0
  ORTHOMAX=300
  EMCUTOFF=3.0
  IONDYNAMICS='verlet'
else
  echo "ERROR: Run number not valid."
  exit 1
fi

awk -v title="$TITLE" -v calculation="$CALCULATION" \
   -v mode="$MODE" -v verbose="$VERBOSITY"\
   -v outdir="$OUTDIR" -v pseudodir="$PSEUDODIR" \
   -v tstress="$TSTRESS" -v tprnfor="$TPRNFOR" \
   -v nstep="$NSTEP" -v dt="$TIMESTEP" \
   -v ndr="$NDR" -v ndw="$NDW" \
   -v iprint="$IPRINT"  -v isave="$ISAVE" -v prefix="$PREFIX" \
   -v ekinconvthr="$EKINCONVTHR" -v etotconvthr="$ETOTCONVTHR" \
   -v forcconvthr="$FORCCONVTHR" \
   -v ibrav="$IBRAV" -v nat="$NAT" \
   -v nbnd="$NBND"\
   -v ntyp="$NTYP" -v ecutwfc="$ECUTWFC" \
   -v electrondynamics="$ELECTRONDYNAMICS" \
   -v electrondamping="$ELECTRONDAMPING" \
   -v electronvelocity="$ELECTRONVELOCITY" \
   -v emass="$EMASS" -v emasscutoff="$EMCUTOFF" \
   -v ampre="$AMPRE" -v startingwfc="$STARTINGWFC" \
   -v orthomax="$ORTHOMAX" -v orthogonalization="$ORTHOGONALIZATION" \
   -v iondynamics="$IONDYNAMICS" \
   -v ionvelocity="$IONVELOCITY" -v iondamping="$IONDAMPING" \
   -v tempw="$TEMPW" -v fnosep="$FNOSEP" \
   '{ sub(/TITLE/, title); sub(/CALCULATION/, calculation);
    sub(/MODE/, mode); sub(/VERBOSE/, verbose);
    sub(/OUTDIR/, outdir); sub(/PSEUDODIR/, pseudodir);
    sub(/TSTRESS/, tstress); sub(/TPRNFOR/, tprnfor);
    sub(/NSTEP/, nstep); sub(/TIMESTEP/, dt);
    sub(/NDR/, ndr); sub(/NDW/, ndw);
    sub(/IPRINT/, iprint); sub(/ISAVE/, isave); sub(/PREFIX/, prefix);
    sub(/EKINCONVTHR/, ekinconvthr); sub(/ETOTCONVTHR/, etotconvthr);
    sub(/FORCCONVTHR/, forcconvthr); sub (/NBND/, nbnd);
    sub(/IBRAV/, ibrav); sub(/NAT/, nat); sub(/NTYP/, ntyp);
    sub(/ECUTWFC/, ecutwfc);
    sub(/ELECTRONDYNAMICS/, electrondynamics);
    sub(/ELECTRONDAMPING/, electrondamping);
    sub(/ELECTRONVELOCITY/, electronvelocity);
    sub(/EMASS/, emass); sub(/EMCUTOFF/, emasscutoff);
    sub(/AMPRE/, ampre); sub(/STARTINGWFC/, startingwfc);
    sub(/ORTHOMAX/, orthomax); sub(/ORTHOGONALIZATION/, orthogonalization);
    sub(/IONDYNAMICS/, iondynamics);
    sub(/IONVELOCITY/, ionvelocity); sub(/IONDAMPING/, iondamping);
    sub(/TEMPW/, tempw); sub(/FNOSEP/, fnosep);
     print}' cu-input.sample | sed '/NULL/d' > cu.in
    cat cu.cif >> cu.in 
 #srun cp.x -input cu.in > log-cu

done
