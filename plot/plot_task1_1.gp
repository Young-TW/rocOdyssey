# set output
set terminal pngcairo size 4096,4096 background rgb 'black'
set output "task1_space_style.png"

# set top-down view
set view map
set size square
unset border
unset tics
unset key

# --- Optimized color palette ---
# Define a physical spectrum color scale from black -> blue -> cyan -> yellow -> red
# 0 (background/black hole) -> black
set palette defined ( \
    0 0 0 0, \
    0.001 0 0 0.5, \
    0.5 0 0.5 1, \
    1.0 1 1 0, \
    1.5 1 0 0 )

# Based on your data, the value range is approximately 0 to 1.3
set cbrange [0:1.35]

# Plot
splot "Output_task1.txt" matrix with image