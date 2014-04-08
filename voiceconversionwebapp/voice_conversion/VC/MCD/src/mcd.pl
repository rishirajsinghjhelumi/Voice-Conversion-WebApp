use strict;
use src::functions;
if($#ARGV != 3)
{
	print "Usage: perl mcd.pl <actual directory - indir> <synthesized directory - indir> <mcd file - outfile> <store-file> \n";
	exit;
}

chomp(@ARGV);
my $actual_dir = $ARGV[0];
my $syn_dir = $ARGV[1];
my $mcd_file = $ARGV[2];
my $outputdir = $ARGV[3];


&cleanDirs($actual_dir, $syn_dir);

opendir(synthdir, $syn_dir) || die("$syn_dir not found\n");
open(mcdfile, ">$mcd_file") || die("$mcd_file can't be created\n");
my $total_mcd = 0;
my $fcnt = 0;
foreach my $file(readdir synthdir)
{
	chomp($file);
	if($file =~ /\.mcep$/)
	{
		print "Processing $file\n";
		$fcnt++;
		my $act_file = $actual_dir."/".$file;
		my $syn_file = $syn_dir."/".$file;
		#print "Synthfile: $syn_file\n";
		my $output;
		my $output = `/home/bajibabu/Lab_work/Voice_conversion/SLT_model/mcd/bin/track_diff_mcd $act_file $syn_file | awk '{print \$2}'`;
		#system("./bin/track_diff_mcd $act_file $syn_file");
		if(-f "ERROR")
		{
			print mcdfile $output;
			chomp($output);
			$total_mcd = $total_mcd + $output;
		}
		else
		{
			my $basename = `basename $syn_file .mcep`;			
			chomp($basename);
			my $lab_file = $syn_dir."/".$basename.".lab";
			#my $lab_file = $syn_dir."/".$basename.".actual.lab";
			#&changeMCEPFiles($act_file,$lab_file);
			my $temp_syn_file = "$syn_file.temp";
			`cp $syn_file $temp_syn_file`;
			&changeMCEPFiles($temp_syn_file,$lab_file);
#			my $filename = `basename $temp_syn_file`;
#			chomp($filename);
#	print "temp file:$filename\n";
#			print "output: $outputdir\n";
#		my $temp_synfile = $temp
			my $output = `/home/bajibabu/Lab_work/Voice_conversion/SLT_model/mcd/bin/track_diff_mcd $act_file $temp_syn_file | awk '{print \$2}'`;
			`cp $temp_syn_file $syn_file`;
			`mv $syn_file $outputdir`;
			#`rm $temp_syn_file`;
			print mcdfile "$file $output";
			chomp($output);
			$total_mcd = $total_mcd + $output;
		}
		#print $output;
	}	
}
my $average = sprintf("%.3f",$total_mcd / $fcnt);
print "Total MCD: $average\n";
print mcdfile "Average: $average\n";
close(selected);
closedir(actdir);

sub changeMCEPFiles
{
	#print "Hello\n";
	my $mcep_file = shift;
	my $lab_file = shift;
	`\$ESTDIR/bin/ch_track $mcep_file -otype ascii -o tmp.file`;
	open(labfile, "$lab_file") || die("$lab_file not found\n");
	open(mcepfile, "tmp.file") || die("tmp.file not found\n");
	open(outfile, ">out.file") || die("out.file can't be created\n");
	my @mcep_lines = <mcepfile>;
	chomp(@mcep_lines);
	my $hashflag = 0;
	foreach my $line(<labfile>)
	{
		chomp($line);
		if($line eq "#")
		{
			$hashflag = 1;
			next;
		}
		next if($hashflag == 0);
		$line =~ s/^\s+//g;
		(my $time, my $tmp, my $num) = split(/\s+/, $line);
		$time = sprintf("%.3f", $time) * 1000;
		$time = $time/5;
		$time =~ s/\..*//g;		
		$time = $time - 1;
		print outfile $mcep_lines[$time]."\n";		
	}
	close(labfile);
	close(mcepfile);
	close(outfile);
	`\$ESTDIR/bin/ch_track -itype ascii out.file -s 0.005 -otype est_binary -o $mcep_file`;
	`rm tmp.file out.file`;
}
