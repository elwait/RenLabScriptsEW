#!/bin/bash


correct_last="15767  K" # first part of correct last line in arc
total_steps=10000000
prodMD_dir="/work/eew947/md_sims/30e_farH_01-11-23/Solv"

# find end of last full frame in arc
# and delete all lines after it (junk)
for arc in ${prodMD_dir}/*/*.arc; do
    echo $arc
    last_line=$(echo ${arc} | tail -1)
    # delete everything after last match of correct last
    sed -i "1,+${correct_last}+!d" $arc
done


 

# using arc (instead of out)
# find how many frames were written
# 10000000 steps desired - number completed = how many need to be added for each run
for arc in /work/eew947/md_sims/30e_farH_01-11-23/Solv/*/*.arc; do
    echo $arc
    #correct_last="15767  K" # first part of correct last line in arc
    steps_done=$(grep -c "${correct_last}" ${arc})
    echo $steps_done
    steps_left=$((${total_steps}-${steps_done}))
    echo $steps_left
done
 
 
 
# find how many frames were written
# 10000000 steps desired - number completed = how many need to be added for each run
#for out in /work/eew947/md_sims/30e_farH_01-11-23/Solv/*/*.out; do
#    echo $out
#    steps_line=$(grep "Instantaneous Values for Frame Saved at" ${out} | tail -1)
#    echo $steps_line
#    #use awk to trim to just the number of steps
#    steps_done=$(echo "${steps_line}" | awk "{print \$7}")
#    echo $steps_done
#    steps_left=$((10000000-${steps_done}))
#    echo $steps_left
#done