#!/bin/bash

indir=$1;
inEx=$2;
outEx=$3;

for i in `ls $indir`
do
	echo $i
	fname=`basename $indir/$i .$inEx`
	echo $fname
	`mv $indir/$i $indir/$fname.$outEx`
done
