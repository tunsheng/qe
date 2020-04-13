from argparse import ArgumentParser, SUPPRESS

if __name__=="__main__":
    parser = ArgumentParser(add_help=False, description="")
    required = parser.add_argument_group('required arguments')
    optional = parser.add_argument_group('optional arguments')
    optional.add_argument('-h', '--help', action='help', default=SUPPRESS,
                              help='show this help message and exit')
    required.add_argument('-i', '--input', help='input file name')
    args = parser.parse_args()

    fname = args.input
    found=False
    energy = []
    totm = []
    absm = []
    alat = []
    kp = []
    kinetic = []
    with open(fname, 'r') as doc:
        found=False
        for idx, line in enumerate(doc):
            if 'lattice parameter' in line:
                x = line.strip().split()
                alat.append(x[4])
            if 'number of k points' in line:
                x = line.strip().split()
                kp.append(x[4])
            if 'kinetic' in line:
                x = line.strip().split()
                kinetic.append(x[3])
            if '!' in line:
                found=True
                c=1
                x = line.strip().split()
                energy.append(x[4])     
            if found:
                x = line.strip().split()
                if c==13 and 'total magnetization' in line:
                    totm.append(x[3])
                if c==14 and 'absolute magnetization' in line:
                    absm.append(x[3])
                c+=1
                if c > 15:
                    found = False
                    c=0

    if totm == []:
        totm = [ 0 ] * len(kinetic)
    if absm == []:
        absm = [ 0 ] * len(kinetic)
    ry2ev=13.605662285137 
    with open('mag.dat', 'w') as doc:
        N = len(energy)
        header="# alat \t nk \t etot \t totm \t absm \t ecutwfc\n"
        doc.write(header)
        outfmt="{alat} \t {kp} \t  {etot} \t {totm} \t {absm} \t {kinec}\n"
        for i in range(N):
            doc.write(outfmt.format(alat=alat[i], kp=kp[i], etot=float(energy[i]), totm=totm[i], absm=absm[i], kinec=kinetic[i]))
