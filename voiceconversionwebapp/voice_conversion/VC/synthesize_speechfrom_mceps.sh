#!/bin/bash

#echo "<usage :<mcep_dir> <f0_dir> <output_dir>"

mcep_dir=$1
f0_dir=$2
output=$3

for i in `ls $mcep_dir |sed 's/.mcep//g'` 
do
	fname=$i
	cat $mcep_dir/$fname.mcep | awk '{for (i=1; i<=NF; i++) printf("%s\n",$i); }' | perl  $FESTVOXDIR/src/clustergen/a2d.pl > input.mcep
	$FESTVOXDIR/src/vc/src/synthesis/synthesis -f 16000 -frame 5.0 -order 24 $f0_dir/$fname.f0 input.mcep $output/$fname.wav
done

rm -rf input.mcep

exit 0
