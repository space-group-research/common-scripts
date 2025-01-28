#!/bin/bash

echo "The first energy guesses are:"
echo "# Ry : Energy in a.u."
for output_file_path in `find -name "runlog.log" | sort`
do
        Ry=`echo $output_file_path | grep -o "[0-9]*"`
        Energy=`grep "1 OT" $output_file_path | head -1 | awk '{print $7}'`
        echo $Ry ":" $Energy    
done
