#!/bin/sh
if [ ! "$ESTDIR" ]
then
   echo "environment variable ESTDIR is unset"
   echo "set it to your local speech tools directory e.g."
   echo '   bash$ export ESTDIR=/home/awb/projects/speech_tools/'
   echo or
   echo '   csh% setenv ESTDIR /home/awb/projects/speech_tools/'
   exit 1
fi

if [ ! "$FESTVOXDIR" ]
then
   echo "environment variable FESTVOXDIR is unset"
   echo "set it to your local festvox directory e.g."
   echo '   bash$ export FESTVOXDIR=/home/awb/projects/festvox/'
   echo or
   echo '   csh% setenv FESTVOXDIR /home/awb/projects/festvox/'
   exit 1
fi

if [ "$CLUSTERGENDIR" = "" ]
then
    export CLUSTERGENDIR=$FESTVOXDIR/src/clustergen
fi


if [ $# = 0 ]
then
  echo "Usage: $0 mcep <prmpF>"
  exit 0
fi

if [ "$PROMPTFILE" = "" ]
then
   if [ $# = 2 ]
   then
      PROMPTFILE=$2
   else
      PROMPTFILE=etc/txt.done.data
   fi
fi

if [ $1 = "mcep" ]
then
   ORDER=24

   cat $PROMPTFILE |
   awk '{print $2}' |
   while read i
   do
      fname=$i
      echo $fname MCEP
      $FESTVOXDIR/src/vc/src/analysis/analysis -shift 5 -mcep -pow -order $ORDER -npowfile ttt.npow wav/$i.wav ttt.mcep
      cat ttt.mcep |
      perl $CLUSTERGENDIR/d2a.pl |
      awk '{printf("%s ",$1); if ((NR%(1+'$ORDER')) == 0) printf("\n")}' |
      $ESTDIR/bin/ch_track -itype ascii -otype ascii -s 0.005 | sed '1 s/^ //g' > mcep/$i.mcep
#     $ESTDIR/bin/ch_track -itype ascii -otype est_binary -s 0.005 -o mcep/$i.mcep
#      cat ttt.npow |
#      perl $CLUSTERGENDIR/d2a.pl |
#      awk '{printf("%s\n",$1);}' |
#      $ESTDIR/bin/ch_track -itype ascii -otype est_binary -s 0.005 -o mcep/$i.npow
      rm -f ttt.mcep
   done
   exit 0
fi

