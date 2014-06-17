#!/bin/bash

read -p "Please input your first name:" firstname
read -p "Please input your last name:" lastname
# -e means enable interpretion for \n. If not, \n will not be recongnized.
echo -e "\nYour full name is : $firstname $lastname"

