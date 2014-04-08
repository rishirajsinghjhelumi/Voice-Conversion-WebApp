#!/bin/bash

SPEAKER_A_TRAIN_MCEP_OUTPUT=$1
SPEAKER_B_TRAIN_MCEP_OUTPUT=$2

SPEAKER_A_TRAIN_MCEP_OUTPUT_BINARY="Speaker_A_Binary_MCEPS"
SPEAKER_B_TRAIN_MCEP_OUTPUT_BINARY="Speaker_B_Binary_MCEPS"

MCEP_ALIGN_DIR="MCEP_Aligned"

#Speaker A
if [ -d $SPEAKER_A_TRAIN_MCEP_OUTPUT_BINARY ]; then
	rm -rf $SPEAKER_A_TRAIN_MCEP_OUTPUT_BINARY
fi
mkdir $SPEAKER_A_TRAIN_MCEP_OUTPUT_BINARY

speakerAMCEPFiles=`ls $SPEAKER_A_TRAIN_MCEP_OUTPUT`
for mcepFile in $speakerAMCEPFiles
do
	$ESTDIR/bin/ch_track -otype est_binary -s 0.005 $SPEAKER_A_TRAIN_MCEP_OUTPUT/$mcepFile > $SPEAKER_A_TRAIN_MCEP_OUTPUT_BINARY/$mcepFile
done

#Speaker B
if [ -d $SPEAKER_B_TRAIN_MCEP_OUTPUT_BINARY ]; then
	rm -rf $SPEAKER_B_TRAIN_MCEP_OUTPUT_BINARY
fi
mkdir $SPEAKER_B_TRAIN_MCEP_OUTPUT_BINARY

speakerBMCEPFiles=`ls $SPEAKER_B_TRAIN_MCEP_OUTPUT`
for mcepFile in $speakerBMCEPFiles
do
	$ESTDIR/bin/ch_track -otype est_binary -s 0.005 $SPEAKER_B_TRAIN_MCEP_OUTPUT/$mcepFile > $SPEAKER_B_TRAIN_MCEP_OUTPUT_BINARY/$mcepFile
done

#DTW

if [ -d $MCEP_ALIGN_DIR ]; then
	rm -rf $MCEP_ALIGN_DIR
fi
mkdir $MCEP_ALIGN_DIR

touch i.lab o.lab

binaryMCEPFiles=`ls $SPEAKER_A_TRAIN_MCEP_OUTPUT_BINARY`
for mcepFile in $binaryMCEPFiles
do
	$FESTVOXDIR/src/general/phonealign \
	-otrack $SPEAKER_A_TRAIN_MCEP_OUTPUT_BINARY/$mcepFile \
	-itrack $SPEAKER_B_TRAIN_MCEP_OUTPUT_BINARY/$mcepFile \
	-ilabel i.lab -olabel o.lab -verbose -withcosts | head -n -1 > $MCEP_ALIGN_DIR/$mcepFile
done

#Actual Alignment

speakerAMCEPFiles=`ls $SPEAKER_A_TRAIN_MCEP_OUTPUT`
for mcepFile in $speakerAMCEPFiles
do
	python mcep_align.py $SPEAKER_A_TRAIN_MCEP_OUTPUT/$mcepFile $MCEP_ALIGN_DIR/$mcepFile
done

#Delete Temporaries
rm -rf i.lab o.lab
rm -rf $SPEAKER_A_TRAIN_MCEP_OUTPUT_BINARY $SPEAKER_B_TRAIN_MCEP_OUTPUT_BINARY $MCEP_ALIGN_DIR

exit 0
