if [ $# != 2 ]; then 
	echo "sh estascii2estbinary.sh <input directory> <output directory>";
	exit;
fi

indir=$1
outdir=$2

if [ -d $outdir ]; then
	echo "$outdir Exists"
else
	mkdir $outdir
fi

ls $indir/*.mcep | while read i
do
	fname=`basename $i`;
#	$ESTDIR/bin/ch_track $i -otype ascii | sed '1 s/^ //g' | cut -d " " -f 2-26 | $ESTDIR/bin/ch_track -itype ascii -otype est_binary -s 0.005 -o $outdir/$fname
	$ESTDIR/bin/ch_track $i -otype ascii | sed '1 s/^ //g' | cut -d " " -f 1-25 | $ESTDIR/bin/ch_track -itype ascii -otype est_binary -s 0.005 -o $outdir/$fname
	echo "Completed $fname"
done
