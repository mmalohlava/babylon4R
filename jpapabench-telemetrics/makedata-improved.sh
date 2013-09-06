#!/bin/bash

function prepare_log { 
    dir=$1
    prefix=$2
    log_file=$3

    output_prefix="$dir/$prefix"
    # position
    echo "X" > ${output_prefix}_x
    head -n 152 ${log_file} | grep ^\| | cut -d \| -f 2 >> ${output_prefix}_x
    echo "Y" > ${output_prefix}_y
    head -n 152 ${log_file} | grep ^\| | cut -d \| -f 3 >> ${output_prefix}_y
    paste -d, ${output_prefix}_x ${output_prefix}_y > ${output_prefix}_pos.csv
    rm ${output_prefix}_x ${output_prefix}_y

    head -n 152 ${log_file} | grep ^\| | cut -d \| -f 4 > ${output_prefix}_heading.csv
    head -n 152 ${log_file} | grep ^\# | cut -d \# -f 2 > ${output_prefix}_hspeed.csv
    head -n 152 ${log_file} | grep ^\# | cut -d \# -f 3 > ${output_prefix}_course.csv
    head -n 152 ${log_file} | grep ^\# | cut -d \# -f 4 > ${output_prefix}_err.csv
    head -n 152 ${log_file} | grep ^\# | cut -d \# -f 5 > ${output_prefix}_last_err.csv
    head -n 152 ${log_file} | grep ^\# | cut -d \# -f 6 > ${output_prefix}_d_err.csv
    head -n 152 ${log_file} | grep ^\# | cut -d \# -f 7 > ${output_prefix}_roll.csv

    echo "gspeed" > ${output_prefix}_gps_gspeed.csv
    head -n 152 ${log_file} | grep ^\? | cut -d \? -f 2 >> ${output_prefix}_gps_gspeed.csv
    echo "course" > ${output_prefix}_gps_course.csv
    head -n 152 ${log_file} | grep ^\? | cut -d \? -f 3 >> ${output_prefix}_gps_course.csv
    echo "climb" > ${output_prefix}_gps_climb.csv
    head -n 152 ${log_file} | grep ^\? | cut -d \? -f 4 >> ${output_prefix}_gps_climb.csv
    echo "fspeed" > ${output_prefix}_gps_fspeed.csv
    head -n 152 ${log_file} | grep ^\? | cut -d \? -f 5 >> ${output_prefix}_gps_fspeed.csv
    echo "fcourse" > ${output_prefix}_gps_fcourse.csv
    head -n 152 ${log_file} | grep ^\? | cut -d \? -f 6 >> ${output_prefix}_gps_fcourse.csv
    echo "fclimb" > ${output_prefix}_gps_fclimb.csv
    head -n 152 ${log_file} | grep ^\? | cut -d \? -f 7 >> ${output_prefix}_gps_fclimb.csv
    paste -d, ${output_prefix}_gps_*.csv > ${output_prefix}_gps.csv
    rm  ${output_prefix}_gps_*.csv
}

prepare_log "log" "jp" "jpapabench_pj.out"
prepare_log "log" "pr" "paparazzi.out"
#echo "X" > log/jp_x
#grep ^\| log/jpapabench_pj.out | head -n 40 | cut -d \| -f 2 >> log/jp_x
#echo "Y" > log/jp_y
#grep ^\| log/jpapabench_pj.out | head -n 40 | cut -d \| -f 3 >> log/jp_y
#paste -d, log/jp_x log/jp_y > log/jp_pos.csv
#grep ^\| log/jpapabench_pj.out | head -n 40 | cut -d \| -f 4 > log/jp_heading
#grep ^\# log/jpapabench_pj.out | tail -n +2 | head -n 40 | cut -d \# -f 2 > log/jp_hspeed
#grep ^\# log/jpapabench_pj.out | tail -n +2 | head -n 40 | cut -d \# -f 3 > log/jp_course
#grep ^\# log/jpapabench_pj.out | tail -n +2 | head -n 40 | cut -d \# -f 4 > log/jp_err
#grep ^\# log/jpapabench_pj.out | tail -n +2 | head -n 40 | cut -d \# -f 5 > log/jp_last_err
#grep ^\# log/jpapabench_pj.out | tail -n +2 | head -n 40 | cut -d \# -f 6 > log/jp_d_err
#grep ^\# log/jpapabench_pj.out | tail -n +2 | head -n 40 | cut -d \# -f 7 > log/jp_roll
#grep ^\? log/jpapabench_pj.out | cut -d \? -f 2 > log/jp_gps_gspeed
#grep ^\? log/jpapabench_pj.out | cut -d \? -f 3 > log/jp_gps_course
#grep ^\? log/jpapabench_pj.out | cut -d \? -f 4 > log/jp_gps_climb
#grep ^\? log/jpapabench_pj.out | cut -d \? -f 5 > log/jp_gps_fspeed
#grep ^\? log/jpapabench_pj.out | cut -d \? -f 6 > log/jp_gps_fcourse
#grep ^\? log/jpapabench_pj.out | cut -d \? -f 7 > log/jp_gps_fclimb
##grep ^\# log/jpapabench_pj.out | head -n 40 | tail -n +2 > log/jp_turn
