#!/bin/bash

# Usage : <Speaker_A_Wav_Folder> <Speaker_B_Wav_Folder>

SPEAKER_A_WAV_DIR=$1
SPEAKER_A_TRAIN_MCEP_OUTPUT="Speaker_A_MCEPS"
SPEAKER_A_MCEP_FILE="Speaker_A.mcep"

SPEAKER_B_WAV_DIR=$2
SPEAKER_B_TRAIN_MCEP_OUTPUT="Speaker_B_MCEPS"
SPEAKER_B_MCEP_FILE="Speaker_B.mcep"

#GET MCEPS
./get_mceps.sh $SPEAKER_A_WAV_DIR $SPEAKER_A_TRAIN_MCEP_OUTPUT
./get_mceps.sh $SPEAKER_B_WAV_DIR $SPEAKER_B_TRAIN_MCEP_OUTPUT

#ALIGN MCEPS
./mcep_align.sh $SPEAKER_A_TRAIN_MCEP_OUTPUT $SPEAKER_B_TRAIN_MCEP_OUTPUT

#COMBINE MCEPS
./mcep_combine.sh $SPEAKER_A_TRAIN_MCEP_OUTPUT $SPEAKER_A_MCEP_FILE
./mcep_combine.sh $SPEAKER_B_TRAIN_MCEP_OUTPUT $SPEAKER_B_MCEP_FILE

#TRAIN MCEPS
ANN_FOLDER="ANN_Train_Test"
OUTPUT_MODEL="ANN_Model"

./$ANN_FOLDER/JustTrain $ANN_FOLDER/parameters $SPEAKER_A_MCEP_FILE $SPEAKER_B_MCEP_FILE $OUTPUT_MODEL 60 0 0.3

rm -rf Err tempwt.txt ValErr

exit 0
