#/bin/bash
echo "Hello! CRM WEB"

export GROUPNAME=aigrp
export JDK=jdk-6u45-linux-x64.bin
export USERAIWEB=aicrmweb
export WEBSERVERPACK=webserver.tar.gz
export TOMCATSERVERPATH=/veris/crm/aicrmweb/webserver/bin
export SERVER_CRM=crm
export SERVER_CS=cs
export SERVER_SSO=sso
export SERVER_UCP=ucp
export SERVER_KBS=kbs
export SERVER_CRM_PORT=8802
export SERVER_CS_PORT=8803
export SERVER_SSO_PORT=8804 
export SERVER_UCP_PORT=8805
export SERVER_KBS_PORT=8806
export SSOPACK=sso.war



##colored definition
export black='\033[0m'
export boldblack='\033[1;0m'
export red='\033[31m'
export boldred='\033[1;31m'
export green='\033[32m'
export boldgreen='\033[1;32m'
export yellow='\033[33m'
export boldyellow='\033[1;33m'
export blue='\033[34m'
export boldblue='\033[1;34m'
export magenta='\033[35m'
export boldmagenta='\033[1;35m'
export cyan='\033[36m'
export boldcyan='\033[1;36m'
export white='\033[37m'
export boldwhite='\033[1;37m'

cecho () {

## -- Function to easliy print colored text -- ##
	
	# Color-echo.
	# Argument $1 = message
	# Argument $2 = color

	local default_msg="No message passed."
	
	message=${1:-$default_msg}	# Defaults to default message.
	
	#change it for fun
	#We use pure names
	color=${2:-black}		# Defaults to black, if not specified.
	
	case $color in
		black)
			 printf "$black" ;;
		boldblack)
			 printf "$boldblack" ;;
		red)
			 printf "$red" ;;
		boldred)
			 printf "$boldred" ;;
		green)
			 printf "$green" ;;
		boldgreen)
			 printf "$boldgreen" ;;
		yellow)
			 printf "$yellow" ;;
		boldyellow)
			 printf "$boldyellow" ;;
		blue)
			 printf "$blue" ;;
		boldblue)
			 printf "$boldblue" ;;
		magenta)
			 printf "$magenta" ;;
		boldmagenta)
			 printf "$boldmagenta" ;;
		cyan)
			 printf "$cyan" ;;
		boldcyan)
			 printf "$boldcyan" ;;
		white)
			 printf "$white" ;;
		boldwhite)
			 printf "$boldwhite" ;;
	esac
	  printf "%s\n"  "$message"
	  tput sgr0			# Reset to normal.
	  printf "$black"
	
	return
}

check_system () {
	cecho "---Operating system Information---" red #boldwhite
	cecho "OS Version: $(lsb_release -a|grep Description|awk -F'\t' '{print $2}')" 
	cecho "CPU: $(cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c)"
	cecho "Device Inodes IUse%: $(df -i /veris|awk '/veris/{printf"%s%s\n",$NF," "$(NF-1)}'|tail -1)"
	cecho "ulimit size: $(ulimit -u)"
	echo 		
}

check_mysql_version () {
## -- Print Version Info -- ##
        local mysql_version_compile_machine=$($mysqlconn -Bse "show /*!50000 global */ variables like 'version'" 2>/dev/null| awk '{ print $2 }')
        cecho "MySQL Version: $db_host $mysql_version_compile_machine"
	cecho "MySQL-Connector: $(rpm -qa | grep -i mysql-connector)"
	cecho "unixODBC: $(rpm -qa | grep -Ei unixODBC-[0-9])" ; echo
}


check_jdk () {
	cecho "---Jdk Information---" boldwhite
	$(java -version) ; echo 
}

install_webserver () {
	#############Create Gourp#########################
	if [ "$GROUPNAME" != `cat /etc/group | grep aigrp | awk -F':' '{print $1}'` ];then
		groupadd aigrp
		cecho "Create group successully!" green
	else
		cecho "Group exits!" red
	fi
	############Create users and Add to Group########
	cecho "Add user into Gourp!" green
	############Install JDK #########################
	if [ ! -e $JDK ]; then
		 cecho "The $JDK DOES NOT exist" red
		 cecho "Please upload the $JDK under $USERAIWEB/ " red
		exit 0
	else 
	#	su - $USERAIWEB -c "sh $JDK"
	#	if [ -d $JDK ];then
	#		mv $JDK java 
	#	fi
		cecho "Install JDK successfully!" green 
	fi	
	
	###############Install WebServer#################
	if [ ! -e $WEBSERVERPACK ];then
		cecho "The $WEBSERVERPACK DOES NOT exist" red
		cecho "Please upload the $WEBSERVERPACK under $USERAIWEB/ " red
		exit 0 
	else	
	 #	su - $USERAIWEB -c "tar -zxf $WEBSERVERPACK"
		cecho  "Uncompress the $WEBSERVERPACK successfully!" green
	fi
	#############Create Tomacat Server##############
	su - $USERAIWEB -c "sh $TOMCATSERVERPATH/createServer.sh $SERVER_CRM $SERVER_CRM_PORT"
	su - $USERAIWEB -c "sh $TOMCATSERVERPATH/createServer.sh $SERVER_CS $SERVER_CS_PORT"
	su - $USERAIWEB -c "sh $TOMCATSERVERPATH/createServer.sh $SERVER_SSO $SERVER_SSO_PORT"
	su - $USERAIWEB -c "sh $TOMCATSERVERPATH/createServer.sh $SERVER_UCP $SERVER_UCP_PORT"
	su - $USERAIWEB -c "sh $TOMCATSERVERPATH/createServer.sh $SERVER_KBS $SERVER_KBS_PORT"
	cecho "Create Tomcat Server Successfully!" green
	##############Configuration SSO#################
	cecho "Configuration SSO !" green
	 if [ ! -e $WEBSERVERPACK ];then
                cecho "The $WEBSERVERPACK DOES NOT exist" red
                cecho "Please upload the $WEBSERVERPACK under $USERAIWEB/ " red
                exit 0
        else
}

install_webserver
check_system
check_jdk
