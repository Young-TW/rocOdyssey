# Set high-resolution output
set terminal pngcairo size 4096,4096 background rgb 'black' fontscale 1.0
set output "task2_interstellar_final_fixed.png"

# Basic view settings
set view map
set size square
unset border
unset tics
unset key
# unset colorbox  # Keep colorbox for now to see the scale

# Color palette (Interstellar style)
set palette defined ( \
    0 0 0 0,      \
    0.1 0.3 0 0,  \
    0.3 0.6 0.1 0, \
    0.5 0.9 0.5 0, \
    0.7 1 0.8 0.3, \
    1 1 1 1 )

# --- CRITICAL FIX START ---

# Method 1: The safest way (Auto-scaling)
# Comment out the fixed range so Gnuplot decides the range based on actual data
# set cbrange [0:2e31]  <-- This line caused the black image

# Method 2: Dynamic Scaling (Recommended)
# We run a statistics check on column 3 (Luminosity) first
stats "Output_task2.txt" using 3 nooutput

# Print the maximum value found to the console (for your reference)
print "Maximum Luminosity found: ", STATS_max

# Set the range from 0 to the maximum value found
set cbrange [0:STATS_max]

# --- CRITICAL FIX END ---

# Plot the image
splot "Output_task2.txt" using 1:2:3 with image