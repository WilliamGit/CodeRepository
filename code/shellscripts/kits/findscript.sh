#!/bin/bash
echo -e "Please input the filename, I will find it"
read -p "The filename : " filename
test -z $filename && echo "You MUST input the filename!" && exit 0

#find the target file under '/' directory 
find / -name "*$filename*" -print | less
#find the target file udner the current directory
find . -name "*$filename*" -print | less
#find all files modified in the last 24 hours (last full day)
# in a particular specific directory and its sub-directories:
find /directory_path -mtime -1 -ls
find $HOME -mtime 0 # less than 24 hours
# file have been modified in the last 60 minutes
find /target_directory -type f -mmin -60
# files have been modified in the last 2 days
find /target_directory -type f -mtime -2
#To search for files in /target_directory and 
#all its sub-directories no more than 3 levels deep, 
#that have been modified in the last 2 days
find /target_directory -type f -mtime -2 -depth -3
#To search for files in /target_directory and all its sub-directories,
# that have been modified in the last 7 days, but not in the last 3 days:
find /target_directory -type f -mtime -7 ! -mtime -3
#To search for files in /target_directory (and all its sub-directories)
#that have been modified in the last 60 minutes, and print out their file attributes:
find /target_directory -type f -mmin -60 | xargs ls -l
#find the target file and test the file type
find . -type f "*$filename*" -print | less
#The above command sorts files in /etc (and all its subdirectories), 
#in the reverse order of their update time, and prints out the sorted list, 
#along with their location and update time. 
find /etc -type f -printf '%TY-%Tm-%Td %TT %p\n' | sort -r
#
