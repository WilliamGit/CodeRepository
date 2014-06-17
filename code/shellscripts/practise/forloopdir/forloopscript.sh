#!/bin/bash

int=1

for $int in 1 2 3 4 5
do
multiply=$($int*$int)
echo $multiply
#count=$($int+1)
#echo $count
done
