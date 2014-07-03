#!/bin/bash
echo -e "You should input two numbers, I will cross them!\n"
read -p "First number : " firstnum
read -p "Second number : " secondnum
total=$(($firstnum*$secondnum))
echo -e "\nThe result of $firstnum * $secondnum is ==> $total"

