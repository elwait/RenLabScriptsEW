#!/bin/bash

# for restarting MD jobs which crash
# requires having a jobs text file with commands that will then be edited

correct_last="15767  K" # first part of correct last line in arc
total_steps=10000000
prodMD_dir="/work/eew947/md_sims/30e_farH_01-11-23"
job_txt="my_jobs.txt"
cp ${prodMD_dir}/${job_txt} ${prodMD_dir}/updated_jobs.txt # make a copy of the job txt file


# find end of last full frame in arc
# and delete all lines after it (junk)
for arc in ${prodMD_dir}/Solv/*/*.arc; do
    echo $arc
    last_line=$(echo ${arc} | tail -1)
    sed -i "1,+${correct_last}+!d" $arc                    # delete everything after last match of correct last
    steps_done=$(grep -c "${correct_last}" ${arc})         # count occurances of correct last line
    echo $steps_done
    steps_left=$((${total_steps}-${steps_done}))           # find number of steps needed to complete
    if (( ${steps_left} == 0 )); then
        echo "This job finished."
        sed -i "+$arc+d" ${prodMD_dir}/updated_jobs.txt    # remove  line from updated_jobs.txt
    else
        echo $steps_left
        file_base=$("${arc}%.arc")
        key="${file_base}.key"
        # find line with this key and change steps to number of steps left
        sed -i "/${key}/s/${total_steps}/${steps_left}/g" ${prodMD_dir}/updated_jobs.txt
        #rm "${prodMD_dir}/Solv/*/${file_base}.dyn"        # remove dyn which is likely corrupted
    fi
    echo "Moving on to next arc..."
done

