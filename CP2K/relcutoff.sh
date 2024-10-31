#!/bin/bash

base=`pwd`
rel_cutoffs=`seq 10 10 100` #start at 10 Ry, make a new directory every 10 steps, ending at 100 Ry
cutoff=950

inp_file=`find . -maxdepth 1 -name '*.inp' | cut -c 3-` #Finds your input file and slices off characters to just have input file name.
echo "Input file is ${inp_file}."

    for rel_cutoff in $rel_cutoffs
    do
        mkdir -p rel_cutoff
        cd rel_cutoff
        mkdir -p $rel_cutoff
        cd $rel_cutoff
        cp $base/start-pos.xyz . #update if file with atomic positions is named differently
        cp $base/cp2k.sh . #update if cp2k submit script is named differently
        sed -e "s/LT_rel_cutoff/${rel_cutoff}/g" $base/${inp_file} > ${inp_file}
        bsub < cp2k.sh
        cd ../..
    done
