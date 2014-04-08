#!/bin/bash

COMBINE_DIR=$1
OUTPUT_FILE=$2

if [ -f $OUTPUT_FILE ]; then
	rm -rf $OUTPUT_FILE
fi
touch $OUTPUT_FILE

speakerF0Files=`ls $COMBINE_DIR`
for F0File in $speakerF0Files
do
	cat $COMBINE_DIR/$F0File >> $OUTPUT_FILE
done

rm -rf $COMBINE_DIR

exit 0
