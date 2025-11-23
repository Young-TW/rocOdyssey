# set 4K resolution output
set terminal pngcairo size 4096,4096 background rgb 'black'
set output "task1_redshift_4k.png"

# set the angle to top-down view
set view map
set size square

# remove border, tics, and key for cleaner look
unset border
unset tics
unset key

# --- Task 1 specific color palette ---
# Use a custom color palette to represent redshift and blueshift
# Blue = blueshift (approaching us), Red = redshift (receding), Black = black hole
set palette rgbformulae 33,13,10

# Force color range to focus on redshift values
# Redshift typically ranges from 0 to about 1.3
set cbrange [0:1.3]

# Plot
splot "Output_task1.txt" w p pt 5 pal