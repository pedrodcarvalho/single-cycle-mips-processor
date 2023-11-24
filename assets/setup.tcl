# Compile the files
vcom *.vhd

# Load the top level entity
eval vsim work.main

# Add the signals to the wave window
add wave -r /*

# Force the clock to 1 for 5000 ps, then 0 for 5000 ps and then repeat
force -freeze sim:/main/ck 1 0, 0 {5000 ps} -r 10ns
