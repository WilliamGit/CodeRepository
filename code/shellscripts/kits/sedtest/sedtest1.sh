#!/bin/bash
#sed won't change the original file, just show the result after command, you can create a new 
#to save what you want.

inputfile=$1

#delete from firt to second line and show the left information.
	#sed '1,2d' $inputfile 
#delete the line that includes the "cn" word ,// represents "search"
	#sed '/cn/d' $inputfile
#delete the line that contains three numerics
	#sed '/[0-9]\{3\}/d' $inputfile
#delete the blank line
	#sed '/^$/d' $inputfile
#delete the line that exclude the "cn"
	#sed '/cn/!d' $inputfile
#print the line that contains the "cn"
	#sed -n '/cn/p' $inputfile
#replace the key word from "cn" to "china"
	#sed -n 's/cn/china/gp' $inputfile
#Delete the key word "china"
	#sed -n 's/china//p' $inputfile
#delete the first 3 charactors for each line
	#sed 's/^...//' $inputfile
#delete the last 3 charactors for each line
	#sed 's/...$//' $inputfile
#find out the 'cn' and replace with 'cnchina'
	#sed -n 's/\(cn\)/\1china/gp' $inputfile
#find out the corresponding charactors and do some substitution operations.
	#sed -n '/CN/s/cn/china/gp' $inputfile
#find out the target lines and do the substitution operations.
#find out the lines that contains 'UK','CN' and replace from '_' to '+'
#Note, the 'UK' and 'CN' should be in order
	#sed -n '/UK/,/CN/s/_/+/gp' $inputfile  
	#or
	sed -n '2,4s/_/+/gp' $inputfile
