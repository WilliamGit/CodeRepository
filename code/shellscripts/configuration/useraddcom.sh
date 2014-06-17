#!/bin/bash
echo 'Hello, useradd!'

ailkprod='Veris'
subprod='crm'

groupadd aigrp
useradd -g aigrp -d /$ailkprod/$subprod/aideploy -s /bin/csh aideploy
useradd -g aigrp -d /$ailkprod/$subprod/aiweb    -s /bin/csh aiweb   
useradd -g aigrp -d /$ailkprod/$subprod/aicrm    -s /bin/csh aicrm   
useradd -g aigrp -d /$ailkprod/$subprod/aics     -s /bin/csh aics    
useradd -g aigrp -d /$ailkprod/$subprod/aiucp    -s /bin/csh aiucp   
useradd -g aigrp -d /$ailkprod/$subprod/aiproxy  -s /bin/csh aiproxy 
useradd -g aigrp -d /$ailkprod/$subprod/aicau    -s /bin/csh aicau   
useradd -g aigrp -d /$ailkprod/$subprod/aiprod   -s /bin/csh aiprod  
useradd -g aigrp -d /$ailkprod/$subprod/aisec    -s /bin/csh aisec   
useradd -g aigrp -d /$ailkprod/$subprod/airedis  -s /bin/csh airedis
useradd -g aigrp -d /$ailkprod/$subprod/mysql    -s /bin/csh mysql
useradd -g aigrp -d /$ailkprod/$subprod/aikbs    -s /bin/csh aikbs
echo "aideploy" | passwd --stdin aideploy
echo "aiweb" | passwd --stdin aiweb   
echo "aicrm" | passwd --stdin aicrm   
echo "aics" | passwd --stdin aics    
echo "aiucp" | passwd --stdin aiucp   
echo "aiproxy" | passwd --stdin aiproxy 
echo "aicau" | passwd --stdin aicau   
echo "aiprod" | passwd --stdin aiprod  
echo "aisec" | passwd --stdin aisec   
echo "airedis" | passwd --stdin airedis
echo "aikbs" | passwd --stdin aikbs

