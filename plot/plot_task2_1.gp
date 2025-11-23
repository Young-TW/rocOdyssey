# Set the terminal to high-resolution PNG with a black background
# "pngcairo" provides the best rendering quality for smooth gradients
set terminal pngcairo size 4096,4096 background rgb 'black' fontscale 1.0
set output "task2_interstellar_log.png"

# Set the view to a 2D map projection (top-down)
# This flattens the calculated data into a 2D image
set view map
set size square

# Remove borders, axis ticks, and legends for a clean, cinematic look
unset border
unset tics
unset key

# Define the "Interstellar" style color palette (Blackbody radiation simulation)
# Color Mapping: Background(Black) -> Red -> Orange -> Gold -> White(Brightest)
# This simulates the temperature gradient of the accretion disk.
set palette defined ( \
    0 0 0 0,      \
    0.1 0.3 0 0,  \
    0.3 0.6 0.1 0, \
    0.5 0.9 0.5 0, \
    0.7 1 0.8 0.3, \
    1 1 1 1 )

# --- CRITICAL CONFIGURATION: LOGARITHMIC SCALE ---
# The brightness of the accretion disk varies by orders of magnitude.
# A linear scale makes the image look black because only the absolute 
# brightest pixels are visible. A log scale allows us to see both 
# the faint and bright regions simultaneously.

# Step 1: Analyze the data to find the maximum luminosity value
stats "Output_task2.txt" using 3 nooutput
print "Maximum Luminosity detected: ", STATS_max

# Step 2: Enable logarithmic scaling for the color axis (cbtics)
set logscale cb

# Step 3: Set the dynamic range
# Lower bound: 1e24 (Must be > 0. Adjusting this affects contrast/noise floor)
# Upper bound: STATS_max (The brightest point found in the simulation)
set cbrange [1e24:STATS_max]

# Render the image
# "using 1:2:3" reads X, Y, and Luminosity columns
# "with image" renders a solid bitmap, eliminating grid gaps
splot "Output_task2.txt" using 1:2:3 with image