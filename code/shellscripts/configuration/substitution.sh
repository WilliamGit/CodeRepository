#!/bin/bash
source_dir=`dirname $0`
find_str=$1
replace_str=$2
targetfile=$3

if [ $# -ne 3 ]
then 
	echo "Usage : `basename $0` find_str replace_str target_file"
	echo "WARNING!"
	exit 1
fi

# This command will replace the original file.
sed -i s/$find_str/$replace_str/ $source_dir/$targetfile
