#!/bin/bash

if [ $# != 3 ] 
then
	echo "sh mcd.sh <input directory> <output directory> <mcd file - outfile>"
	exit;
fi

indir=$1
outdir=$2

#creating two temporary directories
mkdir temp
mkdir temp1

#converting ASCII to Binary 
echo "converting ascii to binary.."
sh ./src/asciitoest.sh $indir temp
sh ./src/asciitoest.sh $outdir temp1

#sh filerename.sh temp1/ mceps mcep

perl ./src/mcd_orig.pl temp temp1 $3

rm -rf temp
rm -rf temp1
