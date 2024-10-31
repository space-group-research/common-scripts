#!/bin/bash

base=`pwd`
cutoffs=`seq -w 250 50 2000` #start at 50 Ry, make a new folder every 250 steps, ending at 2000 Ry
rel_cutoff=60

inp_file=`find . -maxdepth 1 -name '*.inp' | cut -c 3-` #Finds your input file and slices off characters to just have input file name.
echo "Input file is ${inp_file}."

    for cutoff in $cutoffs
    do
        mkdir -p cutoff
        cd cutoff
        mkdir -p $cutoff
        cd $cutoff
        cp $base/start-pos.xyz . #update if you're using a different file name for your atomic positions
        cp $base/cp2k.sh . #update if your cp2k submit script is named differently
        sed -e "s/LT_rel_cutoff/${rel_cutoff}/g" \ #Be sure to update the REL_CUTOFF field in your input script with 'LT_rel_cutoff'
            -e "s/LT_cutoff/${cutoff}/g" $base/${inp_file} > ${inp_file} #Ce sure to update the CUTOFF field in input script with 'LT_cutoff'
        bsub < cp2k.sh
        cd ../..
    done
