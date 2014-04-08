#!/bin/sh

##ctxt=0

if [ $# = 0 ]
then
  echo "Usage $0 mcep/"
  exit
fi

if [ $1 = "mcep" ]
then
 ##Compute MCEPs..
 mkdir mcep
 sh scripts/do_mcep.sh mcep $2
fi

if [ $1 = "cmcep" ]
then
 ##Compute MCEPs..
  tarD=cmcep_ami
  hdrF=pfeat/arffheader_v5
  dictF=pfeat/phonemap_cont_v5_eng.txt.out
  ctxt=0
  mkdir $tarD
  echo $tarD $hdrF $dictF
  perl scripts/gencontext_fem_v2.1.pl $2 mcep_tts $tarD lab $dictF $ctxt
  perl scripts/ascii_to_arff.pl $2 $tarD paf $tarD arff  $hdrF
fi

  
