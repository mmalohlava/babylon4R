echo "X" > log/pr_x
head -n 152 log/paparazzi.out | grep ^\| | cut -d \| -f 2 >> log/pr_x
echo "Y" > log/pr_y
head -n 152 log/paparazzi.out | grep ^\| | cut -d \| -f 3 >> log/pr_y
paste -d, log/pr_x log/pr_y > log/pr_pos.csv
rm log/pr_x log/pr_y

echo "heading" > log/pr_heading
head -n 152 log/paparazzi.out | grep ^\| | cut -d \| -f 4 >> log/pr_heading
echo "hspeed" > log/pr_hspeed
head -n 152 log/paparazzi.out | grep ^\# | cut -d \# -f 2 >> log/pr_hspeed
echo "course" > log/pr_course
head -n 152 log/paparazzi.out | grep ^\# | cut -d \# -f 3 >> log/pr_course
echo "err" > log/pr_err
head -n 152 log/paparazzi.out | grep ^\# | cut -d \# -f 4 >> log/pr_err
echo "last_err" > log/pr_last_err
head -n 152 log/paparazzi.out | grep ^\# | cut -d \# -f 5 >> log/pr_last_err
echo "d_err" > log/pr_d_err
head -n 152 log/paparazzi.out | grep ^\# | cut -d \# -f 6 >> log/pr_d_err
echo "roll" > log/pr_roll
head -n 152 log/paparazzi.out | grep ^\# | cut -d \# -f 7 >> log/pr_roll
paste -d, log/pr_heading log/pr_hspeed log/pr_course log/pr_err log/pr_last_err log/pr_d_err log/pr_roll > log/pr_telemetry.csv
rm log/pr_heading log/pr_hspeed log/pr_course log/pr_err log/pr_last_err log/pr_d_err log/pr_roll 

echo "gspeed" > log/pr_gps_gspeed
head -n 152 log/paparazzi.out | grep ^\? | cut -d \? -f 2 >> log/pr_gps_gspeed
echo "course" > log/pr_gps_course
head -n 152 log/paparazzi.out | grep ^\? | cut -d \? -f 3 >> log/pr_gps_course
echo "climb" > log/pr_gps_climb
head -n 152 log/paparazzi.out | grep ^\? | cut -d \? -f 4 >> log/pr_gps_climb
echo "fspeed" > log/pr_gps_fspeed
head -n 152 log/paparazzi.out | grep ^\? | cut -d \? -f 5 >> log/pr_gps_fspeed
echo "fcourse" > log/pr_gps_fcourse
head -n 152 log/paparazzi.out | grep ^\? | cut -d \? -f 6 >> log/pr_gps_fcourse
echo "fclimb" > log/pr_gps_fclimb
head -n 152 log/paparazzi.out | grep ^\? | cut -d \? -f 7 >> log/pr_gps_fclimb
paste -d, log/pr_gps_* > log/pr_gps.csv
rm log/pr_gps_*
#head -n 69 log/paparazzi.out | grep ^\# > log/pr_turn

echo "X" > log/jp_x
grep ^\| log/jpapabench_pj.out | head -n 40 | cut -d \| -f 2 >> log/jp_x
echo "Y" > log/jp_y
grep ^\| log/jpapabench_pj.out | head -n 40 | cut -d \| -f 3 >> log/jp_y
paste -d, log/jp_x log/jp_y > log/jp_pos.csv
rm log/jp_x log/jp_y

echo "heading" > log/jp_heading
grep ^\| log/jpapabench_pj.out | head -n 40 | cut -d \| -f 4 >> log/jp_heading
echo "hspeed" > log/jp_hspeed
grep ^\# log/jpapabench_pj.out | tail -n +2 | head -n 40 | cut -d \# -f 2 >> log/jp_hspeed
echo "course" > log/jp_course
grep ^\# log/jpapabench_pj.out | tail -n +2 | head -n 40 | cut -d \# -f 3 >> log/jp_course
echo "err" > log/jp_err
grep ^\# log/jpapabench_pj.out | tail -n +2 | head -n 40 | cut -d \# -f 4 >> log/jp_err
echo "last_err" > log/jp_last_err
grep ^\# log/jpapabench_pj.out | tail -n +2 | head -n 40 | cut -d \# -f 5 >> log/jp_last_err
echo "d_err" > log/jp_d_err
grep ^\# log/jpapabench_pj.out | tail -n +2 | head -n 40 | cut -d \# -f 6 >> log/jp_d_err
echo "roll" > log/jp_roll
grep ^\# log/jpapabench_pj.out | tail -n +2 | head -n 40 | cut -d \# -f 7 >> log/jp_roll
paste -d, log/jp_heading log/jp_hspeed log/jp_course log/jp_err log/jp_last_err log/jp_d_err log/jp_roll > log/jp_telemetry.csv
rm log/jp_heading log/jp_hspeed log/jp_course log/jp_err log/jp_last_err log/jp_d_err log/jp_roll 

echo "gspeed" > log/jp_gps_gspeed
grep ^\? log/jpapabench_pj.out | cut -d \? -f 2 >> log/jp_gps_gspeed
echo "course" > log/jp_gps_course
grep ^\? log/jpapabench_pj.out | cut -d \? -f 3 >> log/jp_gps_course
echo "climb" > log/jp_gps_climb
grep ^\? log/jpapabench_pj.out | cut -d \? -f 4 >> log/jp_gps_climb
echo "fspeed" > log/jp_gps_fspeed
grep ^\? log/jpapabench_pj.out | cut -d \? -f 5 >> log/jp_gps_fspeed
echo "fcourse" > log/jp_gps_fcourse
grep ^\? log/jpapabench_pj.out | cut -d \? -f 6 >> log/jp_gps_fcourse
echo "fclimb" > log/jp_gps_fclimb
grep ^\? log/jpapabench_pj.out | cut -d \? -f 7 >> log/jp_gps_fclimb
paste -d, log/jp_gps_* > log/jp_gps.csv
rm log/jp_gps_*

#grep ^\# log/jpapabench_pj.out | head -n 40 | tail -n +2 > log/jp_turn
