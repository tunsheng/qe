# Plot total energy vs lattice constant
set samples 500
set xlabel "Lattice constant (bohr)" 
set ylabel "Total energy per unit cell (Ry)" 
p 'total_energy.dat' u 1:2 smooth csplines lc 1 lw 4  notitle,\
  'total_energy.dat' u 1:2 w p ls 1 lc 2 lw 4 pt 4 notitle

pause -1

