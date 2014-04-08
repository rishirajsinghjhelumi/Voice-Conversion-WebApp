#!/bin/bash

WAV_FOLDER=$1
OUTPUT_FILE=$2

wavFiles=`ls $WAV_FOLDER | cut -d"." -f1`

for file in $wavFiles
do
	echo "( $file \"\" )" >> $OUTPUT_FILE
done

exit 0