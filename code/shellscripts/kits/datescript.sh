#!/bin/bash

date1=$(date --date='2 days ago' +%Y%m%d) #the date before 2 days
date2=$(date --date='1 days ago' +%Y%m%d) #the date before 1 day
date3=$(date +%Y%m%d)	#Current date
file1=${filename}${date1}
file2=${filename}${date2}
file3=${filename}${date3}

echo $file1 $file2 $file3



