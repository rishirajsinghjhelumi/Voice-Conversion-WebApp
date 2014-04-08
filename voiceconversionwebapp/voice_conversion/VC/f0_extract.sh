#!/bin/bash
#<usage : <wav-dir> 

WAV_DIR=$1
OUTPUT_WAV_DIR=$1.f0

if [ -d $OUTPUT_WAV_DIR ]; then
	rm -rf $OUTPUT_WAV_DIR
fi
mkdir $OUTPUT_WAV_DIR

for i in `ls $WAV_DIR|sed 's/.wav//g'`
do
	fname=$i
	$ESTDIR/bin/pda $WAV_DIR/$fname.wav -o $WAV_DIR.f0/$fname.f0 -shift 0.005 -S 0.025 -L
done

exit 0
