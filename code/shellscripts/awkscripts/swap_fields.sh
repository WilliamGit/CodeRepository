#!/bin/bash

script_dir=`dirname $0`
#source $script_dir/settings.sh

if [ $# -ne 2 ]
then
        echo "Usage: `basename $0` source_file output_dir"
        echo "WARNING! output_dir will be emptied!"
        exit 1
fi

source_file=$1
output_dir=$2

#$HADOOP_HOME/bin/hadoop fs -rmr $output_dir

#$PIG_HOME/bin/pig \
 #       -param input_file="$source_file"\
 #       -param output_file="$output_dir"\
 #       -file $script_dir/swap_fields.pig\
 #       -logfile $PIG_LOG_DIR

