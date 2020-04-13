import numpy as np
from argparse import ArgumentParser, SUPPRESS

THZ_CM=33.35641

def same(a,b):
    for i in range(len(a)):
        if abs(a[i]-b[i]) > 1e-16:
            return False
    return True

if __name__=="__main__":
    parser = ArgumentParser(add_help=False, description="")
    required = parser.add_argument_group('required arguments')
    optional = parser.add_argument_group('optional arguments')
    optional.add_argument('-h', '--help', action='help', default=SUPPRESS,
                              help='show this help message and exit')
    optional.add_argument('-s', '--symmetry', default='highsym.txt',
                            help='high symmetry points file')
    required.add_argument('-i', '--input', help='input file name')
    
    args = parser.parse_args()

    fname = args.input
    bands=[]
    kpoints=[]
    extraction=False
    with open(fname, 'r') as doc:
        for idx, line in enumerate(doc):
            if "&plot" in line:
                x = line.strip().split()
                nbnd=int(x[2].replace(',', ''))
                nks=int(x[4])
                extraction=True
                is_q=True
                continue
            if extraction:
                x = line.strip().split()
                if is_q:
                    kpoints.append(x)
                else:
                    bands.append(x)
                is_q = not is_q
    bands = np.array(bands, dtype=np.float64)
    kpoints = np.array(kpoints, dtype=np.float64)
    highsym = np.loadtxt(args.symmetry, dtype=object)
    highsym_energy = []
    with open('band_structure.dat', 'w') as doc:
        pathL = 0.0
        scontent = "".join("\t"+"{:8.5f}".format(x/THZ_CM) for x in bands[0,:])
        c=0
        if same(kpoints[0,:], np.array(highsym[c,1:], dtype=np.float64)):
            doc.write(highsym[c,0]+"\t{:08.4f}".format(pathL)+scontent+"\n")
            c+=1
            highsym_energy.append(pathL)
        else:
            doc.write("Z\t{:08.4f}".format(pathL)+scontent+"\n")
        for i in range(1, nks):
            pathL += np.linalg.norm(kpoints[i,:]-kpoints[i-1,:])
            scontent = "".join("\t"+"{:8.5f}".format(x/THZ_CM)  for x in bands[i,:])
            if same(kpoints[i,:], np.array(highsym[c,1:], dtype=np.float64)):
                doc.write(highsym[c,0]+"\t{:08.4f}".format(pathL)+scontent+"\n")
                c+=1
                highsym_energy.append(pathL)
            else:
                doc.write("Z\t{:08.4f}".format(pathL)+scontent+"\n")

    with open('plotband.gp', "w") as doc:
        N = len(highsym_energy)
        ymax = np.max(bands.flatten()/THZ_CM)*1.2
        for i in range(N):
            doc.write("set arrow from "+str(highsym_energy[i])+",0 to "+str(highsym_energy[i])+","+str(ymax)+" nohead lw 2\n")
        labels = ",".join("'"+highsym[i,0]+"' "+str(highsym_energy[i]) for i in range(N))
        doc.write("set xtics("+labels+")\n")
        doc.write("set yrange [0:"+str(ymax)+"]\n")
        doc.write("\n")
        doc.write("p ")
        for i in range(nbnd):
            doc.write("  'band_structure.dat' u 2:($"+str(i+3)+") w l lw 2 lc 1 notitle,\\\n")
        doc.write("\n")
        doc.write("pause -1 'Press any key'")

