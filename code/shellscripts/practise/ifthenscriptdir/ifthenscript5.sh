#!/bin/bash

echo "This program will try to calculate :"
echo "How many days before your demobilization date..."
read -p "Please input your demobilization date (YYYYMMDD ex>20090401): " date2

#Test whether the result is right or not

#date_d=$(echo $date2 | grep "[0-9]\{8\}")  the expression is also right
date_d=$(echo $date2 | grep '[0-9]\{8\}')
if [ "$date_d" == "" ]; then
	echo "Your input the wrong date foramt..."
	exit 1
fi

#Start calculating the date
#%s     seconds since '00:00:00 1970-01-01 UTC' (a GNU extension)
#declare 
