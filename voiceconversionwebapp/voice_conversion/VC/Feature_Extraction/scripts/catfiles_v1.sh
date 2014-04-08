#!/bin/sh
if [ ! $# == 6 ]; then
  echo "Usage: $0 <prmptF> <inDir> <inExt> <outDir> <outExt> <cat-prefix>"
  exit
fi 

PRMPF=$1
inD=$2
inE=$3
ouD=$4
ouE=$5
preF=$6
inF=$preF."in"
ouF=$preF."out"

echo -n > $inF
echo -n > $ouF

cat $PRMPF | awk '{print $2}' | 
while read i
do
 echo $i
 num=$(cat $inD/$i.$inE | wc | awk '{print $1}')
 numo=$(cat $ouD/$i.$ouE | wc | awk '{print $1}')

 if [ $num -gt $numo ]
 then
   echo "$num (AAF lines) is greater than $numo (MCEP)"
   head -n $numo $inD/$i.$inE >> $inF 
   cat $ouD/$i.$ouE >> $ouF 
   #exit
 else 
   cat $inD/$i.$inE >> $inF 
   head -n $num $ouD/$i.$ouE >> $ouF 
 fi

done
perl scripts/addheader.pl $inF $preF."ina"
perl scripts/addheader.pl $ouF $preF."outa"

