#!/bin/bash
script_dir=`dirname $0`

if [ $# -ne 2 ]
then
        echo "Usage: `basename $0` backupfoldername appname"
        echo "WARNING!, 2 arguments"
        exit 1
fi

backupfoldername=$1
appname=$2

if [ ! -d "$backupfoldername" ] 
then
	echo "Creat the backupfolder!"
	mkdir ${backupfoldername}
fi

read -p "Do you want to eliminate the logfile? (Y/N):" yn

if [ "$yn" == "Y" ] || [ "$yn" == "y" ]
then
	find ./${appname} -name "*.log" | xargs rm -f
	tar -zcf ./${backupfoldername}/${appname}.tar.gz ${appname}/ 
	if [ "$?" -ne 0 ]; then
		echo "Compress failure!"
	else
		echo "Compress Successful!"
	fi			  
	exit 0
fi

if [ "$yn" == "N" ] || [ "$yn" == "n" ] 
then
	tar -zcf ./${backupfoldername}/${appname}.tar.gz ${appname}/
	if [ "$?" -ne 0 ]; then
		echo "Compress failure!"
	else	
		echo "Compress Successful!"
	fi
	exit 0
fi



