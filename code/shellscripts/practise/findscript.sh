#!/bin/bash
echo -e "Please input the filename, I will find it"
read -p "The filename : " filename
test -z $filename && echo "You MUST input the filename!" && exit 0

find / -name "*$filename*" -print | less
