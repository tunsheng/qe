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
#  2 - restart wavefunction optimization
#  3 - structural optimization
#  4 - MD run
RUNS=5

#################
# COMMON INPUTS #
#################

# CONTROL
TITLE='Mg2SiGe'
CALCULATION='cp'
OUTDIR='./'
PSEUDODIR='/home/pseudo'
TSTRESS='.TRUE.'    # Default: false
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
NAT=2      # Number of atoms in unit cell
NTYP=1     # Number of types of atoms in unit cell
ECUTWFC=30.0
NBND=4     # Number of electronics states/bands

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


if [ $RUNS -eq 1 ];
then #  1 - wavefunction optimization
  MODE='from_scratch'
  ISAVE=20
  NDR=90
  NDW=91
  TIMESTEP=0.5d0
  NSTEP=200
  ELECTRONDYNAMICS='damp'
  ELECTRONDAMPING=0.2
  EMASS=700.0
  EMCUTOFF=3.0
  AMPRE=0.01
  STARTINGWFC='random'
  ORTHOGONALIZATION='Gram-Schmidt'
  IONDYNAMICS='none'
elif [ $RUNS -eq 2 ];
then #  2 - restart wavefunction optimization
  MODE='restart'
  ISAVE=40
  NSTEP=200
  NDR=91
  NDW=92
  ETOTCONVTHR='1.e-7'
  ELECTRONDYNAMICS='damp'
  ELECTRONDAMPING=0.2
  EMASS=700.0
  EMCUTOFF=3.0
  ORTHOMAX=100
  IONDYNAMICS='none'
elif [ $RUNS -eq 3 ];
then #  3 - structural optimization
  MODE='restart'
  NDR=94
  NDW=941
  ISAVE=20
  TIMESTEP=0.5d0
  NSTEP=200
  EKINCONVTHR='1.e-5'
  ETOTCONVTHR='1.e-7'
  FORCCONVTHR='1.e-5'
  ELECTRONDYNAMICS='damp'
  ELECTRONVELOCITY='zero'
  ELECTRONDAMPING=0.001
  EMASS=500.0
  EMCUTOFF=3.0
  ORTHOMAX=100
  IONDYNAMICS='damp'
  IONVELOCITY='zero'
  IONDAMPING=0.02
elif [ $RUNS -eq 4 ];
then #  4 - MD run
  MODE='reset_counters'
  NSTEP=100
  IPRINT=1
  ISAVE=10
  TIMESTEP=8
  NDR=92
  NDW=932
  ELECTRONDYNAMICS='verlet'
  EMASS=500.0
  ORTHOMAX=100
  EMCUTOFF=3.0
  ORTHOMAX=100
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
    sub(/FORCCONVTHR/, forcconvthr);
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
     print}' h-input.sample | sed '/NULL/d' > h.in
