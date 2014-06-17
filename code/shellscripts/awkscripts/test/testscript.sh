#!/bin/bash
echo 'Hello, my first job'
source_dir=`dirname $0`
echo $source_dir/../

if [ $# -ne 2 ]
then 
	echo 'wrong'
else 	
	echo 'right'
exit 1
fi
