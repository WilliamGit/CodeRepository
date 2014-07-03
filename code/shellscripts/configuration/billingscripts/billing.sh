#!/bin/sh

#########################################################################
#									#
#########################################################################
##variable definition
export db_host='10.226.5.119'
export db_port='3307'
export db_user='billing'
export db_pass='Ch1qQMXH'
export LOCAL_IP='10.226.5.118'
export JAVA_HOME='/usr/lib/jvm/java-1.6.0-openjdk-1.6.0.0.x86_64'
export user_1='aibilling'
export user_2='aiocs'
export user_3="aiweb"
export BILLING_HOME='/veris/billing/aibilling'
export ip_num='118'
export mysqlconn="mysql -h$db_host -u$db_user -p$db_pass -P$db_port"
export jboss_bin="$BILLING_HOME/jboss-as-7.1.1.Final/bin"
export db_hostname="db.telenor.ailk"
export dev_billing_host="sandbox.billing.telenor.dk"
export dev_ucp_host="sandbox.ucp.telenor.dk"
export dev_sso_host="sandbox.sso.telenor.dk"
export ta_billing_host="ta.billing.telenor.ailk"
export tb_billing_host="tb.billing.telenor.ailk"
export app_crm_host="app.crm.telenor.ailk"
export cookie_domain="telenor.dk"

#port
export console_port='9990'
export acctmgnt_port='9110'
export sysmgnt_port='9080'
export aicas_port='9090'
export dbm2_port='9100'
export productmgnt_port='9140'
export infosystem_port='9130'
export acctcfg_port='9120'
export jobmanager_port='9160'
export billrun_port='9150'
export redomanager_port='9170'
export xdrinquiry_port='9180'
export aiatp_port='9190'

export abm_mdb_port='33505'
export billing_mdb_port='33805'
export dupcheck_mdb_port='33000'
export overlapdupcheck_mdb_port='33100'
export session_mdb_port='33600'
export user_mdb_port='33400'
export billsample_abm_mdb_port='33810'
export billsample_billing_mdb_port='33210'
export ras_mdb_port='33805'
export ras_mdb_ha_port='43655'
export rating_export_mdb_port='11400'
export abm_frame_port='25001'
export abm_mdb_ha_port='43955'
export billing_mdb_ha_port='43355'
export user_mdb_ha_port='43555'
export billing_frame_port='35000'
export billdata_mdb_port='33666'
export abm_confirmbill_port='26001'
export soaserver_port="10020"

export SRM_PORT='43335'
export NRM_PORT='43366'
export UDP_PORT='42222'
export portal_servername_port='8806'

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
	cecho "---Operating system Information---" boldwhite
	cecho "OS Version: $(lsb_release -a|grep Description|awk -F'\t' '{print $2}')" 
	cecho "CPU: $(cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c)"
	cecho "Device Inodes IUse%: $(df -i /veris|awk '/veris/{printf"%s%s\n",$NF," "$(NF-1)}'|tail -1)"
	cecho "ulimit size: $(ulimit -u)"
	echo 
		
}

check_jdk () {
	cecho "---Jdk Information---" boldwhite
	$(java -version) ; echo 
}

check_mysql_login () {

## -- Test for running mysql -- ##
	cecho "---DB Information---" boldwhite
        is_up=$(mysqladmin -h$db_host -P$db_port -u$db_user -p$db_pass ping 2>/dev/null)
        if [ "$is_up" = "mysqld is alive" ] ; then
		cecho "MySQL Status: $db_host mysqld is alive"
        elif [ "$is_up" != "mysqld is alive" ] ; then
                printf "\n"
                cecho "- MYSQL INITIAL LOGIN ATTEMPT FAILED -" red
                return 1

        else
                cecho "Unknow exit status" red
                exit -1
        fi
}

check_mysql_version () {

## -- Print Version Info -- ##

        local mysql_version_compile_machine=$($mysqlconn -Bse "show /*!50000 global */ variables like 'version'" 2>/dev/null| awk '{ print $2 }')
        cecho "MySQL Version: $db_host $mysql_version_compile_machine"
	cecho "MySQL-Connector: $(rpm -qa | grep -i mysql-connector)"
	cecho "unixODBC: $(rpm -qa | grep -Ei unixODBC-[0-9])" ; echo
}


install_backstage_environment () {
	
	#修改.cshrc文件内容
	cecho "Start backup file .cshrc to .cshrc.bak" boldgreen
	su - $user_1 -c "cp .cshrc .cshrc.bak"
	cecho "Began to replace the .cshrc content" boldgreen
	su - $user_1 -c "sed -i 's#^setenv SRM_IP .*#setenv SRM_IP '"$LOCAL_IP"'#g' .cshrc"
	su - $user_1 -c "sed -i 's#^setenv ODBCINI .*#setenv ODBCINI \$HOME\/odbc.ini#g' .cshrc"
	su - $user_1 -c "sed -i 's#^setenv JAVA_HOME .*#setenv JAVA_HOME '"$JAVA_HOME"'#g' .cshrc"

        su - $user_1 -c "sed -i 's#^setenv SRM_PORT .*#setenv SRM_PORT '"$SRM_PORT"'#g' .cshrc"
        su - $user_1 -c "sed -i 's#^setenv NRM_PORT .*#setenv NRM_PORT '"$NRM_PORT"'#g' .cshrc"
        su - $user_1 -c "sed -i 's#^setenv UDP_PORT .*#setenv UDP_PORT '"$UDP_PORT"'#g' .cshrc"
        su - $user_1 -c "sed -i 's#^setenv SRM_IP .*#setenv SRM_IP '"$ta_billing_host"'#g' .cshrc"
	cecho "Display file .cshrc with .cshrc.bak different" boldgreen
	su - $user_1 -c "/usr/bin/diff .cshrc .cshrc.bak"
	
	#创建Log目录
	cecho "Create a log directory" boldgreen
	su - $user_1 -c "mkdir –p log/abm_mdb log/aierr log/ams log/billdata log/billdata_mdb log/billing log/dbe log/InfoSystem log/nrm log/ras_mdb log/srm log/ts log/unload log/user_mdb"	
	
	#修改SRM配置文件中的数据库名
	cecho "Start backup file srm_1_5_1.xml to srm_1_5_1.xml.bak" boldgreen
	su - $user_1 -c "cp config/srm/srm_1_5_1.xml config/srm/srm_1_5_1.xml.bak"
        cecho "Began to replace the srm_1_5_1.xml content" boldgreen
	su - $user_1 -c "sed -i '/<database>/,/<\/database>/s/<name>[0-9]*_[0-9]*_/<name>'"$ip_num"'_'"$db_port"'_/g;s/<uid>.*<\/uid>/<uid>'"$db_user"'<\/uid>/g;s/<pwd>.*<\/pwd>/<pwd>'"$db_pass"'<\/pwd>/g' config/srm/srm_1_5_1.xml"	
	cecho "Display file srm_1_5_1.xml with srm_1_5_1.xml_bak different" boldgreen
	su - $user_1 -c "/usr/bin/diff srm_1_5_1.xml srm_1_5_1.xml.bak"
	
	#修改MDB配置文件
	cecho "Start backup file route.ctl to route.ctl.bak" boldgreen
	su - $user_1 -c "cp $BILLING_HOME/mdbroute/route.ctl mdbroute/route.ctl.bak"
        cecho "Began to replace the route.ctl content" boldgreen
	su - $user_1 -c "sed 's#/.*/mdbroute/#'"$BILLING_HOME"'/mdbroute/#g' mdbroute/route.ctl"
	cecho "Display file route.ctl with route.ctl.bak different" boldgreen
        su - $user_1 -c "/usr/bin/diff mdbroute/route.ctl mdbroute/route.ctl.bak"
	
	cecho "Start backup file USERMDB.ctl to USERMDB.ctl.bak" boldgreen
        su - $user_1 -c "cp mdb/user_mdb/USERMDB.ctl mdb/user_mdb/USERMDB.ctl.bak"
        cecho "Began to replace the USERMDB.ctl content" boldgreen
        su - $user_1 -c "sed 's#/.*/user_mdb/#'"$BILLING_HOME"'/mdb/user_mdb/#g' mdb/user_mdb/USERMDB.ctl"
	cecho "Display file USERMDB.ctl with USERMDB.ctl.bak different" boldgreen
	su - $user_1 -c "/usr/bin/diff mdb/user_mdb/USERMDB.ctl mdb/user_mdb/USERMDB.ctl.bak"

	#修改odbc.ini配置文件
        cecho "Start backup file odbc.ini to odbc.ini.bak" boldgreen
        su - $user_1 -c "cp odbc.ini odbc.ini.bak"
        cecho "Began to replace the odbc.ini content" boldgreen
	su - $user_1 -c "sed -i 's/\[[0-9]*_[0-9]*_/['"$ip_num"'_'"$db_port"_'/g;s/^SERVER=.*/SERVER='"$db_host"'/g;s/^UID=.*/UID='"$db_user"'/g;s/^PWD=.*/PWD='"$db_pass"'/g;s/^PORT=.*/PORT='"$db_port"'/g' odbc.ini"
	
}

install_reception_environment () {
	cecho "Begin installing the front desk environment" boldgreen	
	
	#在数据库内修改前台各模块的配置信息
	$mysqlconn -e "update MD.SYS_MENU  set application ='http://$dev_billing_host:$dbm2_port/dbm' where system_id=900;commit;"	

	#更新系管菜单
	$mysqlconn -e "update MD.SYS_MENU  set application ='http://$dev_billing_host:$sysmgnt_port/sysmgnt' where system_id=100;commit;"
	
	#更新DBM参数配置信息
	$mysqlconn -e "update id.pdc_system_param set param_value='$ta_billing_host' where param_name='dbe.srmhost';commit;"	
	$mysqlconn -e "update id.pdc_system_param set param_value='http://$dev_billing_host:$aicas_port/aicas' where param_name='sso.cas.url';commit;"	
	$mysqlconn -e "update id.pdc_system_param set param_value='$tb_billing_host:$dbm2_port' where param_name='sso.dbm2.serverName';commit;"	
	$mysqlconn -e "update id.pdc_system_param set param_value='$ta_billing_host' where param_name='cluster.instance.1.flex.serverip';commit;"	
	$mysqlconn -e "update id.pdc_system_param set param_value='http://$dev_billing_host:$sysmgnt_port/sysmgnt' where param_name='sysmgnt.app.url';commit;"	
	
	#更新云平台的数据库配置参数
	$mysqlconn -e "update id.pdc_flow_srv_param_db set name=REPLACE(name,SUBSTRING_INDEx(name,'_',2),'"$ip_num"_"$db_port"'),host='$db_hostname',URL=concat(SUBSTRING_INDEx(url,'/',2),'/$db_hostname:$db_port/',SUBSTRING_INDEx(url,'/',-1)),USER_NAME='$db_user',PORT='$db_port' where name<> 'billing_db';commit;"
	$mysqlconn -e "update id.pdc_flow_srv_param_db set host='$db_hostname',URL=concat(SUBSTRING_INDEx(url,'/',2),'/$db_hostname:$db_port/',SUBSTRING_INDEx(url,'/',-1)),USER_NAME='$db_user',PORT='$db_port' where name='billing_db';commit;"
	
	#更新云平台的SAL置参数，修改各MDB的IP
	$mysqlconn -e "update id.pdc_flow_srv_param_oth set cfg_value='$ta_billing_host' where cfg_type=1 and cfg_name like '%_ip';commit;"	
	$mysqlconn -e "update id.pdc_flow_srv_param_oth set cfg_value='$abm_mdb_port' where cfg_type=1 and cfg_name='abm_mdb_port';commit;"
	$mysqlconn -e "update id.pdc_flow_srv_param_oth set cfg_value='$billing_mdb_port' where cfg_type=1 and cfg_name='billing_mdb_port';commit;"
	$mysqlconn -e "update id.pdc_flow_srv_param_oth set cfg_value='$dupcheck_mdb_port' where cfg_type=1 and cfg_name='dupcheck_mdb_port';commit;"
	$mysqlconn -e "update id.pdc_flow_srv_param_oth set cfg_value='$overlapdupcheck_mdb_port' where cfg_type=1 and cfg_name='overlapdupcheck_mdb_port';commit;"
	$mysqlconn -e "update id.pdc_flow_srv_param_oth set cfg_value='$session_mdb_port' where cfg_type=1 and cfg_name='session_mdb_port';commit;"
	$mysqlconn -e "update id.pdc_flow_srv_param_oth set cfg_value='$user_mdb_port' where cfg_type=1 and cfg_name='user_mdb_port';commit;"
	$mysqlconn -e "update id.pdc_flow_srv_param_oth set cfg_value='$billsample_abm_mdb_port' where cfg_type=1 and cfg_name='billsample_abm_mdb_port';commit;"
	$mysqlconn -e "update id.pdc_flow_srv_param_oth set cfg_value='$billsample_billing_mdb_port' where cfg_type=1 and cfg_name='billsample_billing_mdb_port';commit;"
	$mysqlconn -e "update id.pdc_flow_srv_param_oth set cfg_value='$ras_mdb_port' where cfg_type=1 and cfg_name='ras_mdb_port';commit;"
	$mysqlconn -e "update id.pdc_flow_srv_param_oth set cfg_value='$ras_mdb_ha_port' where cfg_type=1 and cfg_name='ras_mdb_ha_port';commit;"
	$mysqlconn -e "update id.pdc_flow_srv_param_oth set cfg_value='$rating_export_mdb_port' where cfg_type=1 and cfg_name='rating_export_mdb_port';commit;"
	$mysqlconn -e "update id.pdc_flow_srv_param_oth set cfg_value='$abm_frame_port' where cfg_type=1 and cfg_name='abm_frame_port';commit;"
	$mysqlconn -e "update id.pdc_flow_srv_param_oth set cfg_value='$abm_mdb_ha_port' where cfg_type=1 and cfg_name='abm_mdb_ha_port';commit;"
	$mysqlconn -e "update id.pdc_flow_srv_param_oth set cfg_value='$billing_mdb_ha_port' where cfg_type=1 and cfg_name='billing_mdb_ha_port';commit;"
	$mysqlconn -e "update id.pdc_flow_srv_param_oth set cfg_value='$user_mdb_ha_port' where cfg_type=1 and cfg_name='user_mdb_ha_port';commit;"
	$mysqlconn -e "update id.pdc_flow_srv_param_oth set cfg_value='$billing_frame_port' where cfg_type=1 and cfg_name='billing_frame_port';commit;"
	$mysqlconn -e "update id.pdc_flow_srv_param_oth set cfg_value='$billdata_mdb_port' where cfg_type=1 and cfg_name='billdata_mdb_port';commit;"
	$mysqlconn -e "update id.pdc_flow_srv_param_oth set cfg_value='$abm_confirmbill_port' where cfg_type=1 and cfg_name='abm_confirmbill_port';commit;"
	
	#更新xdrinquiry菜单
	$mysqlconn -e "update MD.SYS_MENU SYS_MENU set application ='http://$dev_billing_host:$xdrinquiry_port/xdrinquiry' where menu_id in (select menu_id from md.sys_menu t where t.application like '%xdrinquiry%');commit;"	

	#更新Acctmgnt菜单
	$mysqlconn -e "update MD.SYS_MENU SYS_MENU set application ='http://$dev_billing_host:$acctmgnt_port/Acctmgnt' where menu_id in (select menu_id from md.sys_menu t where t.application like '%Acctmgnt%');commit;"

	#更新acctcfg菜单
	$mysqlconn -e "update MD.SYS_MENU SYS_MENU set application ='http://$dev_billing_host:$acctcfg_port/acctcfg' where menu_id in (select menu_id from md.sys_menu t where t.application like '%acctcfg%');commit;"

	#更新InfoSystem菜单	
	$mysqlconn -e "update MD.SYS_MENU SYS_MENU set application ='http://$dev_billing_host:$infosystem_port/InfoSystem' where menu_id in (select menu_id from md.sys_menu t where t.application like '%InfoSystem%');commit;"	
	
	#设置帐管界面跳转信管界面参数配置
	$mysqlconn -e "update sd.sys_parameter set param_value='http://$dev_billing_host:$infosystem_port/InfoSystem' where param_code='IMS_CONTEXT_PATH';commit;"
	$mysqlconn -e "update sd.sys_parameter set param_value='http://$dev_billing_host:$infosystem_port/InfoSystem/page/modules/customerMgmt/complexQuery.jsp?modulId=33' where param_code='SEARCH_BTN_URL';commit;"
	$mysqlconn -e "update sd.sys_parameter set param_value='http://$dev_billing_host:$jobmanager_port/jobmanager/ws/extIntfServiceWs?wsdl' where param_code='CA_CONNECT_JOB_URL';commit;"
	$mysqlconn -e "update sd.sys_parameter set param_value='http://$app_crm_host:$soaserver_port/services/SOAService' where param_code='crm_ws_sync';commit;"

	#jobmanager菜单
	$mysqlconn -e "UPDATE MD.SYS_MENU SET application='http://$dev_billing_host:$jobmanager_port/jobmanager' WHERE application LIKE '%jobmanager%';commit;"

	#billrun菜单
	$mysqlconn -e "UPDATE MD.SYS_MENU SET application='http://$dev_billing_host:$billrun_port/billrun' WHERE application LIKE '%billrun%';commit;"

	#更新各流程的VM信息，让流程不要指定特定的VM
	$mysqlconn -e "update id.pdc_flow_srv set vm_id = 0 where vm_id != 0;commit;"
	$mysqlconn -e "update id.rdc_flow_srv set vm_id = 0  where vm_id != 0;commit;"

	#Client Config
	$mysqlconn -e "update md.sys_param set param_value='http://$dev_billing_host:$sysmgnt_port/sysmgnt/page/modules/user/main.jsp' where param_code='Sysmgnt Client Config';commit;"
	$mysqlconn -e "update md.sys_param set param_value='http://$dev_billing_host:$aicas_port/aicas' where param_code='Aicas Client Config';commit"
	$mysqlconn -e "update md.sys_param set param_value='http://$dev_billing_host:$redomanager_port/redomanager' where param_code='Redo Client Config';commit"
	$mysqlconn -e "update md.sys_param set param_value='http://$dev_billing_host:$jobmanager_port/jobmanager' where param_code='Job Client Config';commit"

	#update mdb info
	$mysqlconn -e "update id.pdc_mdb_info set host='$LOCAL_IP';commit;"


	#更新ocsruler配置文件
	su - $user_2 -c "find . -name '*.cfg' | xargs sed -i 's/10.10.12.84/$LOCAL_IP/g'"

	cecho "Reception environmental installation is complete" boldgreen

}

each_system_deployment () {

	cecho "The beginning of each system deployment" boldgreen
	app_config_file=$(su - $user_1 -c "env | grep AppConfig|cut -d '=' -f2")
	su - $user_3 -c "sed -i 's#jdbc:mysql://.*/#jdbc:mysql://'"$db_hostname"':'"$db_port"'/#g;s#.username=.*#.username='"$db_user"'#g;s#password=.*#password='"$db_pass"'#g' $app_config_file"

	#sysmgnt（系管）部署
	
	su - $user_3 -c "$jboss_bin/jboss-cli.sh --connect --controller=127.0.0.1:9999 'deploy $BILLING_HOME/war/sysmgnt.war --server-groups=sysmgnt'"
	read -p "Please log in jboss, start infosystem services. Then press the Enter key to continue:" -n 1	

	#aicas（单点登陆）部署
	su - $user_3 -c "$jboss_bin/jboss-cli.sh --connect --controller=127.0.0.1:9999 'deploy $BILLING_HOME/war/aicas.war --server-groups=aicas'"
	read -p "Please log in jboss, start aicas services. Then press the Enter key to continue:" -n 1	

	#DBM部署
	su - $user_3 -c "$jboss_bin/jboss-cli.sh --connect --controller=127.0.0.1:9999 'deploy $BILLING_HOME/war/dbm.war --server-groups=dbm'"
	read -p "Please log in jboss, start dbm services. Then press the Enter key to continue:" -n 1	

	#DBE（后台）部署
	$mysqlconn -e "update id.pdc_system_param set PARAM_VALUE='$ta_billing_host' where PARAM_NAME='cluster.instance.1.flex.serverip';commit;"
	$mysqlconn -e "update id.pdc_system_param set PARAM_VALUE='true' where PARAM_NAME='dbe.com.debug';commit;"
	$mysqlconn -e "update id.pdc_system_param set PARAM_VALUE='5000' where PARAM_NAME='dbe.reconnect.interval';commit;"
	$mysqlconn -e "update id.pdc_system_param set PARAM_VALUE='20000' where PARAM_NAME='dbe.regist.timeout';commit;"
	$mysqlconn -e "update id.pdc_system_param set PARAM_VALUE='$ta_billing_host' where PARAM_NAME='dbe.srmhost';commit;"
	$mysqlconn -e "update id.pdc_system_param set PARAM_VALUE='$SRM_PORT' where PARAM_NAME='dbe.srmport';commit;"
	$mysqlconn -e "update id.pdc_system_param set PARAM_VALUE='60' where PARAM_NAME='dv.cpp.ts.timeoutsec';commit;"
	$mysqlconn -e "update id.pdc_system_param set PARAM_VALUE='1.0.0' where PARAM_NAME='dv.flow.initversion';commit;"
	$mysqlconn -e "update id.pdc_system_param set PARAM_VALUE='180' where PARAM_NAME='dv.java.ts.timeoutsec';commit;"
	$mysqlconn -e "update id.pdc_system_param set PARAM_VALUE='$jobmanager_port' where PARAM_NAME='job.servicePort';commit;"
	$mysqlconn -e "update id.pdc_system_param set PARAM_VALUE='http://$dev_billing_host:$aicas_port/aicas' where PARAM_NAME='sso.cas.url';commit;"
	$mysqlconn -e "update id.pdc_system_param set PARAM_VALUE='dbm' where PARAM_NAME='sso.dbm2.contextName';commit;"
	$mysqlconn -e "update id.pdc_system_param set PARAM_VALUE='$tb_billing_host:$dbm2_port' where PARAM_NAME='sso.dbm2.serverName';commit;"
	$mysqlconn -e "update id.pdc_system_param set PARAM_VALUE='http://$dev_billing_host:$sysmgnt_port/sysmgnt' where PARAM_NAME='sysmgnt.app.url';commit;"	
	su - $user_1 -c "nrm"
	su - $user_1 -c "srm"
	read -p "Please log in dbm,srm whether to start. Then press the Enter key to continue:" -n 1
	
	#Productmgnt（产品管理）部署
	su - $user_3 -c "cd war;mkdir tmp_productmgnt;cp productmgnt.war tmp_productmgnt/;cd tmp_productmgnt;jar -xf productmgnt.war"
	su - $user_3 -c "sed -i 's/^db.host=.*/db.host='"$db_hostname"'/g;s/^db.port=.*/db.port='"$db_port"'/g;s/^db.user=.*/db.user='"$db_user"'/g;s/^db.password=.*/db.password='"$db_pass"'/g' war/tmp_productmgnt/WEB-INF/classes/jef.properties"
	su - $user_3 -c "sed -i 's#http://.*/sysmgnt/#http://'"$dev_billing_host:$sysmgnt_port"'/sysmgnt/#g' war/tmp_productmgnt/WEB-INF/classes/sysmgnt-ws.properties"
	su - $user_3 -c "sed -i 's#jdbc:mysql://.*/ad?#jdbc:mysql://'"$db_hostname:$db_port"'/ad?#g' war/tmp_productmgnt/WEB-INF/classes/datasource.xml"
	su - $user_3 -c "cat war/tmp_productmgnt/WEB-INF/classes/datasource.xml|awk '/jdbc:mysql:/{getline;print NR}'|while read line_num
	do
		sed -i ''"$line_num"'s#value=".*"#value="'"$db_user"'"#g' war/tmp_productmgnt/WEB-INF/classes/datasource.xml
	done"
	su - $user_3 -c "cat war/tmp_productmgnt/WEB-INF/classes/datasource.xml|awk '/jdbc:mysql:/{getline;getline;print NR}')|while read line_num
	do
		sed -i ''"$line_num"'s#value=".*"#value="'"$db_pass"'"#g' war/tmp_productmgnt/WEB-INF/classes/datasource.xml
	done"
	servername_line=$(cat war/tmp_productmgnt/WEB-INF/web.xml|awk '/edu.yale.its.tp.cas.client.filter.serverName/{getline;print NR}')
	su - $user_3 -c "sed -i 's#http://.*/aicas/#http://'"$dev_billing_host:$aicas_port"'/aicas/#;s#service=http://.*/productmgnt/#service=http://'"$dev_billing_host:$productmgnt_port"'/productmgnt/#;'"$servername_line"'s#<param-value>.*</param-value>#<param-value>'"$dev_billing_host:$productmgnt_port"'</param-value>#g' war/tmp_productmgnt/WEB-INF/web.xml"
	su - $user_3 -c "cd war/tmp_productmgnt/;rm -rf productmgnt.war;jar -cf productmgnt.war *;cd ../;mv productmgnt.war bak.productmgnt.war;mv tmp_productmgnt/productmgnt.war .;rm -rf tmp_productmgnt"
	su - $user_3 -c "$jboss_bin/jboss-cli.sh --connect --controller=127.0.0.1:9999 'deploy $BILLING_HOME/war/prodcumgnt.war --server-groups=prodcumgnt'"
	read -p "Please log in jboss, start upc services. Then press the Enter key to continue:" -n 1	

	#InfoSystem（信管）部署
	su - $user_3 -c "cd war;mkdir tmp_infosystem;cp infosystem.war tmp_infosystem/;cd tmp_infosystem;jar -xf infosystem.war"
	su - $user_3 -c "sed -i 's#jdbc:mysql://.*/ad?#jdbc:mysql://'"$db_hostname:$db_port"'/ad?#g' war/tmp_infosystem/WEB-INF/classes/infosystemweb_mysql_datasource.xml"
	su - $user_3 -c "cat war/tmp_infosystem/WEB-INF/classes/infosystemweb_mysql_datasource.xml|awk '/jdbc:mysql:/{getline;print NR}'|while read line_num
	do
		sed -i ''"$line_num"'s#value=".*"#value="'"$db_user"'"#g' war/tmp_infosystem/WEB-INF/classes/infosystemweb_mysql_datasource.xml
	done"
	su - $user_3 -c "cat war/tmp_infosystem/WEB-INF/classes/infosystemweb_mysql_datasource.xml|awk '/jdbc:mysql:/{getline;getline;print NR}'|while read line_num
        do
                sed -i ''"$line_num"'s#value=".*"#value="'"$db_pass"'"#g' war/tmp_infosystem/WEB-INF/classes/infosystemweb_mysql_datasource.xml
        done"
	su - $user_3 -c "sed -i 's/^db.host=.*/db.host='"$db_hostname"'/g;s/^db.port=.*/db.port='"$db_port"'/g;s/^db.user=.*/db.user='"$db_user"'/g;s/^db.password=.*/db.password='"$db_pass"'/g' war/tmp_infosystem/WEB-INF/classes/jef.properties"
	su - $user_3 -c "sed -i 's#http://.*/sysmgnt/#http://'"$dev_billing_host:$sysmgnt_port"'/sysmgnt/#g' war/tmp_infosystem/WEB-INF/classes/sysmgnt-ws.properties"
	su - $user_3 -c "sed -i 's#jdbc:mysql://.*/id?#jdbc:mysql://'"$db_hostname:$db_port"'/id?#g;s#db.username=.*#db.username='"$db_user"'#g;s#db.password=.*#db.password='"$db_pass"'#g' war/tmp_infosystem/WEB-INF/classes/AppConfig.properties"
	servername_line=$(cat war/tmp_infosystem/WEB-INF/web.xml|awk '/edu.yale.its.tp.cas.client.filter.serverName/{getline;print NR}')
	su - $user_3 -c "sed -i 's#http://.*/aicas/#http://'"$dev_ucp_host:$aicas_port"'/aicas/#;'"$servername_line"'s#<param-value>.*</param-value>#<param-value>'"$dev_ucp_host:$infosystem_port"'</param-value>#g' war/tmp_infosystem/WEB-INF/web.xml"	
	
	su - $user_3 -c "cd war/tmp_infosystem/;rm -rf infosystem.war;jar -cf infosystem.war *;cd ../;mv infosystem.war bak.infosystem.war;mv tmp_infosystem/prod
uctmgnt.war .;rm -rf tmp_infosystem"
	$mysqlconn -e "update MD.SYS_MENU  SYS_MENU  set application ='http://$dev_billing_host:$infosystem_port/InfoSystem' where menu_id in(select menu_id from md.sys_menu t where t.application like '%InfoSystem%');"
	su - $user_3 -c "$jboss_bin/jboss-cli.sh --connect --controller=127.0.0.1:9999 'deploy $BILLING_HOME/war/infosystem.war --server-groups=infosystem'"	
	read -p "Please login http://$dev_billing_host:$dbm2_port/dbm/, start dbm services. Then press the Enter key to continue:" -n 1
	
	#AcctMgnt（帐管）部署
	su - $user_3 -c "cd war;mkdir tmp_acctmgnt;cp acctmgnt.war tmp_acctmgnt/;cd tmp_acctmgnt;jar -xf acctmgnt.war"
	su - $user_3 -c "sed -i 's/^db.host=.*/db.host='"$db_hostname"'/g;s/^db.port=.*/db.port='"$db_port"'/g;s/^db.user=.*/db.user='"$db_user"'/g;s/^db.password=.*/db.password='"$db_pass"'/g' war/tmp_acctmgnt/WEB-INF/classes/jef.properties"
        su - $user_3 -c "sed -i 's#jdbc:mysql://.*/ad?#jdbc:mysql://'"$db_hostname:$db_port"'/ad?#g' war/tmp_acctmgnt/WEB-INF/classes/acct_web_datasource.xml"
        su - $user_3 -c "cat war/tmp_acctmgnt/WEB-INF/classes/acct_web_datasource.xml|awk '/jdbc:mysql:/{getline;print NR}'|while read line_num
        do
                sed -i ''"$line_num"'s#value=".*"#value="'"$db_user"'"#g' war/tmp_acctmgnt/WEB-INF/classes/acct_web_datasource.xml
        done"
        su - $user_3 -c "cat war/tmp_acctmgnt/WEB-INF/classes/acct_web_datasource.xml|awk '/jdbc:mysql:/{getline;getline;print NR}')|while read line_num
        do
                sed -i ''"$line_num"'s#value=".*"#value="'"$db_pass"'"#g' war/tmp_acctmgnt/WEB-INF/classes/acct_web_datasource.xml
        done"	
	servername_line=$(cat war/tmp_acctmgnt/WEB-INF/web.xml|awk '/portal-servername/{getline;print NR}')
	su - $user_3 -c "sed -i ''"$servername_line"'s#<param-value>.*</param-value>#<param-value>'"$dev_sso_host:$portal_servername_port"'</param-value>#g' war/tmp_acctmgnt/WEB-INF/web.xml"
	servername_line=$(cat war/tmp_acctmgnt/WEB-INF/web.xml|awk '/cookie-domain/{getline;print NR}')
        su - $user_3 -c "sed -i ''"$servername_line"'s#<param-value>.*</param-value>#<param-value>'"$cookie_domain"'</param-value>#g' war/tmp_acctmgnt/WEB-INF/web.xml"
	
	su - $user_3 -c "cd war/tmp_acctmgnt/;rm -rf acctmgnt.war;jar -cf acctmgnt.war *;cd ../;mv acctmgnt.war bak.acctmgnt.war;mv tmp_acctmgnt/prod
uctmgnt.war .;rm -rf tmp_acctmgnt"
	$mysqlconn -e "update MD.SYS_MENU  SYS_MENU  set application ='http://$dev_billing_host:$acctmgnt_port/Acctmgnt' where menu_id in(select menu_id from md.sys_menu t where t.application like '%Acctmgnt%');"
	$mysqlconn -e "update  sd.sys_parameter set param_value='http://$dev_billing_host:$infosystem_port/infosystem' where param_code='IMS_CONTEXT_PATH';"
	$mysqlconn -e "update  sd.sys_parameter set param_value='http://$dev_billing_host:$infosystem_port/infosystem/page/modules/customerMgmt/complexQuery.jsp?modulId=33' where param_code='SEARCH_BTN_URL';"
	su - $user_3 -c "$jboss_bin/jboss-cli.sh --connect --controller=127.0.0.1:9999 'deploy $BILLING_HOME/war/acctmgnt.war --server-groups=acctmgnt'"
	read -p "Please login http://$dev_billing_host:$dbm2_port/dbm/, start dbm services. Then press the Enter key to continue:" -n 1	

	#Acctcfg部署
	su - $user_3 -c "$jboss_bin/jboss-cli.sh --connect --controller=127.0.0.1:9999 'deploy $BILLING_HOME/war/acctmgnt.war --server-groups=acctmgnt'" #疑问（一样？）
	$mysqlconn -e "update MD.SYS_MENU SYS_MENU set application ='http://$dev_billing_host:$acctcfg_port/acctcfg' where menu_id in (select menu_id from md.sys_menu t where t.application like '%acctcfg%');"	
	read -p "Please log in jboss, start acctcfg services. Then press the Enter key to continue:" -n 1	
	
	#jobmanager部署
	su - $user_3 -c "$jboss_bin/jboss-cli.sh --connect --controller=127.0.0.1:9999 'deploy $BILLING_HOME/war/job.war --server-groups=job'"
	read -p "Please log in jboss, start job services. Then press the Enter key to continue:" -n 1

	#billrun部署
	su - $user_3 -c "$jboss_bin/jboss-cli.sh --connect --controller=127.0.0.1:9999 'deploy $BILLING_HOME/war/info.war --server-groups=info'" #疑问（一样？）
	##/home/souser/Oracle/Middleware/user_projects/domains/base_domain/war/billrun_mysql/WEB-INF/web.xml
	##/home/souser/Oracle/Middleware/user_projects/domains/base_domain/war/billrun_mysql/WEB-INF/classes/billrun_datasource.xml
	read -p "Please login http://$dev_billing_host:$dbm2_port/dbm/, start dbm services. Then press the Enter key to continue:" -n 1
	
	#redomanager部署	
	su - $user_3 -c "$jboss_bin/jboss-cli.sh --connect --controller=127.0.0.1:9999 'deploy $BILLING_HOME/war/info.war --server-groups=info'" #疑问（一样？）
	##/home/souser/Oracle/Middleware/user_projects/domains/base_domain/war/redomanager_mysql/WEB-INF/web.xml
	##/home/souser/Oracle/Middleware/user_projects/domains/base_domain/war/redomanager_mysql/WEB-INF/classes/redo_datasource.xml
	read -p "Please log in jboss, start redomanager services. Then press the Enter key to continue:" -n 1

	#aiatp（拨测）部署
	su - $user_3 -c "$jboss_bin/jboss-cli.sh --connect --controller=127.0.0.1:9999 'deploy $BILLING_HOME/war/info.war --server-groups=info'" #疑问（一样？）
	##/home/souser/Oracle/Middleware/user_projects/domains/base_domain/war/aiatp_mysql/WEB-INF/classes/datasource.xml
	read -p "Please log in jboss, start aiatp services. Then press the Enter key to continue:" -n 1 	

	#xdrinquery（详单查询）部署
	su - $user_3 -c "$jboss_bin/jboss-cli.sh --connect --controller=127.0.0.1:9999 'deploy $BILLING_HOME/war/info.war --server-groups=info'" #疑问（一样？）
	##/home/souser/Oracle/Middleware/user_projects/domains/base_domain/war/xdrinquery_mysql/WEB-INF/web.xml
	##/home/souser/Oracle/Middleware/user_projects/domains/base_domain/war/xdrinquery_mysql/WEB-INF/classes/datasource.xml
	$mysqlconn -e "update MD.SYS_MENU  SYS_MENU  set application ='http://$dev_billing_host:$xdrinquiry_port/xdrinquiry' where menu_id in (select menu_id from md.sys_menu t where t.application like '%xdrinquiry%');"
	read -p "Please login http://$dev_billing_host:$dbm2_port/dbm/, start dbm services. Then press the Enter key to continue:" -n 1

	#升级说明
	
}

install_multi_tenant_environments () {
	cecho "null null" boldyellow
}

install_ODBC_related () {

	cecho "Begin installing UNIX ODBC" boldgreen

	#6.8.1 Unixodbc的安装
	tar zxvf unixODBC-2.3.1.tar.gz
	cd unixODBC-2.3.1
	./configure --prefix=/usr/local/unixODBC-2.3.1 --includedir=/usr/include --libdir=/usr/lib64 --bindir=/usr/bin --sysconfdir=/etc
	make
	make install

	cecho "Begin installing mysql-connector-odbc" boldgreen
	
	#MyODBC的安装
	rpm -ivh mysql-connector-odbc-5.2.5-1.el6.x86_64.rpm --nodeps

	#创建数据驱动
	myodbc-installer -d -a -n "MySQL ODBC 5.2 Driver" -t "DRIVER=/usr/lib64/libmyodbc5w.so;SETUP=/usr/lib64/ libodbcmyS.so"
	
	#创建数据源
	myodbc-installer -s -a -c2 -n "dsn_name" -t "DRIVER=MySQL ODBC 5.2 Driver;SERVER=localhost;DATABASE=otl_test;UID=user;PWD=pwd"

	#为普通用户设置环境变量
	echo "为普通用户设置环境变量"	
}

all () {
	install_backstage_environment	  ; echo
	install_reception_environment     ; echo
	each_system_deployment            ; echo
	install_multi_tenant_environments ; echo
	install_ODBC_related              ; echo
}

print_banner () {
cechon "	-- MYSQL PERFORMANCE TUNING PRIMER --" boldyellow
cecho " -- By: Matthew Montgomery -" boldyellow
}

check_system
check_jdk
check_mysql_login
check_mysql_version

if [ -z "$1" ] ; then
	mode='NULL'
else
	mode=$1
fi

case $mode in 
	all | ALL )
	cecho " "
	all
	;;
	backstage | BACKSTAGE )
	cecho " "
	install_backstage_environment ; echo 
	;;
	reception | RECEPTION )
	install_reception_environment ; echo
	;;
	each_system | EACH_SYSTEM )
	each_system_deployment ; echo
	;;
	multi_tenant | MULTI_TENANT )
        install_multi_tenant_environments ; echo
        ;;
        odbc | ODBC )
        install_ODBC_related ; echo
        ;;
	*)
	cecho "usage: $0 [ all | backstage | reception | each_system | multi_tenant | odbc ]" boldred
	exit 1  
	;;
esac
