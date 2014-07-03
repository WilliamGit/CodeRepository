#!/bin/bash
source_dir=`dirname $0`

$source_dir/practise.conf

read -p "Please input (Y/N): " yn

if [ "$yn" == "Y" ] || [ "$yn" == "y" ] 
then
# or ## if ********************************** ; then
	echo " OK, continue"
	exit 0
fi
if [ "$yn" == "N" ] || [ "$yn" == "n" ] 
then
# or ## ************************************ ; then
	echo "Oh, interrupt!"
	exit 0
fi

echo " I don't know what your choice is " && exit 0

