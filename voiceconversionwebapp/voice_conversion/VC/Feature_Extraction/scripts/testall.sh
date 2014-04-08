#!/bin/sh
if [ ! $# == 7 ]; then
  echo "Usage: $0 <prmptF> <inDir> <inExt> <outDir> <outExt> <nnparam> <nnWt>"
  exit
fi 

PRMPF=$1
inD=$2
inE=$3
ouD=$4
ouE=$5
nnP=$6
nnW=$7

cat $PRMPF | awk '{print $2}' | 
while read i
do
 echo $i
 cp $inD/$i.$inE t.mcep
 perl scripts/addheader.pl t.mcep t1.mcep
 ./nnbin/JustTest $nnP t1.mcep $ouD/$i.$ouE $nnW
done

rm -f t.mcep t1.mcep
