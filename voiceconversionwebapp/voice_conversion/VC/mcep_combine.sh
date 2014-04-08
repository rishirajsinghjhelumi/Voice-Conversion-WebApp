#!/bin/bash

#Combine Speaker MCEPS
SPEAKER_TRAIN_MCEP_OUTPUT=$1
SPEAKER_MCEP_FILE=$2

if [ -f $SPEAKER_MCEP_FILE ]; then
	rm -rf $SPEAKER_MCEP_FILE
fi
touch $SPEAKER_MCEP_FILE

speakerMCEPFiles=`ls $SPEAKER_TRAIN_MCEP_OUTPUT`
for mcepFile in $speakerMCEPFiles
do
	cat $SPEAKER_TRAIN_MCEP_OUTPUT/$mcepFile >> $SPEAKER_MCEP_FILE
done

rm -rf $SPEAKER_TRAIN_MCEP_OUTPUT

#Speaker Insert MCEP Dimensions
mcepDimensionSpeaker=`wc -l $SPEAKER_MCEP_FILE | cut -d" " -f1`
echo "$mcepDimensionSpeaker 25" |cat - $SPEAKER_MCEP_FILE > /tmp/out && mv /tmp/out $SPEAKER_MCEP_FILE

exit 0