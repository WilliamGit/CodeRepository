#!/bin/bash


read -p "Please input (Y/N):" yn
[ "$yn" == "Y" -o "$yn" == "y" ] && echo "OK, continue" && exit 0
[ "$yn" == "N" -o "$yn" == "n" ] && echo "Oh, interrupt!" && exit 0
echo " I don't know what your choice is "&& exit 0
# -o means or



#Test whether the value of the HOME is null or not
[ -z "$HOME" ] ; echo $?
#or
#Test whether the value of HOME and MAIL is equal or not
[ "$HOME" == "$MAIL" ] ; echo $?
#or
#Test
name="Bird"
[ "$name" == "Bird" ] ; echo $?


