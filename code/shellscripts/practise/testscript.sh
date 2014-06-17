#!/bin/bash
# Please user input the filename and whether the filename is null or not.
echo -e "Please input a filename, I will check the filename's type and \
permission. \n\n"
read -p "Input a filename : " filename
test -z $filename && echo "You MUST input a filename," && exit 0
# Test whether the file is existing or not.If not existing, show the message
test ! -e $filename && echo "The filename $filename DO NOT exist" && exit 0
# Test the type of the file
test -f $filename && filetype="regular file" 
test -d $filename && filetype="directory"
test -r $filename && perm="readable"
test -w $filename && perm="$perm writable"       
test -x $filename && perm="$perm executable"
# Output the prompt
echo "The filename: $filename is a $filetype"
echo "And the permission are :$perm"
