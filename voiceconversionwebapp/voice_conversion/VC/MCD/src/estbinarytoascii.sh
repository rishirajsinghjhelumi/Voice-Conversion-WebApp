#!/bin/bash

if [ $# != 2 ]
then
	echo "Usage: sh $0 <input dir> <output dir>"
	exit;
fi

indir=$1
outdir=$2

for i in `ls $indir`
do
	fname=`basename $i`
	echo $fname
	$ESTDIR/bin/ch_track $indir/$i -otype ascii  -o $outdir/$fname
done

