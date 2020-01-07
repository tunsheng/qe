# Get total energy for different lattice constant

grep '\!' cu.pwscf.*.out | awk '{print $1, $5}' | sed -e 's/cu.pwscf.//g' | sed -e 's/.out:!//g'> total_energy.dat

# For interactive plot
gnuplot lattice_parameter_plot.gp
 
#For non-interactive plot
#gnuplot -persist <<-EOFMarker
#set samples 500
#set xlabel "Lattice constant (bohr)" 
#set ylabel "Total energy per unit cell (Ry)" 
#p 'total_energy.dat' u 1:2 smooth csplines lc 1 lw 4  notitle,\
#  'total_energy.dat' u 1:2 w p ls 1 lc 2 lw 4 pt 4 notitle
#
#pause -1
#EOFMarker
