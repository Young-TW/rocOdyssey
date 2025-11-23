# Set the terminal to high-resolution PNG with a black background
# Use pngcairo for better rendering quality
# Adjust size to 4096 or 8192 depending on your generated data
set terminal pngcairo size 4096,4096 background rgb 'black' fontscale 1.0

# Set the output filename
set output "task2_interstellar_final.png"

# CRITICAL: Set the view to "map" (top-down 2D projection)
# The 3D inclination (80 deg) is already baked into the simulation data.
# This command ensures Gnuplot treats the data as a flat image, not a 3D terrain.
set view map

# Ensure the aspect ratio is square so the black hole isn't stretched
set size square

# Remove all borders, axis ticks, and legends for a clean "space photo" look
unset border
unset tics
unset key

# Optional: Remove the color gradient bar on the right
# Uncomment the following line if you want a purely cinematic look
# unset colorbox

# Define the color palette (Interstellar style / Blackbody radiation)
# Color mapping: Black -> Dark Red -> Orange -> Gold -> White
# This simulates the temperature gradient of the accretion disk
set palette defined ( \
    0 0 0 0,      \
    0.1 0.3 0 0,  \
    0.3 0.6 0.1 0, \
    0.5 0.9 0.5 0, \
    0.7 1 0.8 0.3, \
    1 1 1 1 )

# Set the brightness range (Luminosity)
# Since the Doppler beaming makes one side extremely bright, we clamp the range
# to ensure the faint parts are still visible.
# Adjust '2e31' based on your actual data intensity.
set cbrange [0:2e31]

# Plot the data
# "using 1:2:3" reads X coordinate, Y coordinate, and Intensity
# "with image" renders a smooth pixel map, filling gaps between data points
splot "Output_task2.txt" using 1:2:3 with image