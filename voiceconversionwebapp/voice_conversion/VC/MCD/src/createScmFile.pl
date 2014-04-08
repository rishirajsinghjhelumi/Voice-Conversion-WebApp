use strict;
use src::functions;

if($#ARGV != 2)
{
	print "perl createScmFile.pl <input file> <output file> <out dir name>\n";
	print "Input file: it should be in txt.done.data format\n";
	print "Output file: scm file\n";
	print "out dir: It will just create a directory to copy the mcep files during synthesis\n";
	exit;
}

chomp(@ARGV);

my $in_file = $ARGV[0];
my $out_file = $ARGV[1];
my $out_dir_name = $ARGV[2];
&creatDirs($out_dir_name);

open(scmfile, ">$out_file") || die("$out_file can't be created\n");

my @lines = &readFile($in_file);

print scmfile "(voice_cmu_us_emma_cg)\n";

foreach my $line(@lines)
{
	$line =~ s/\s+$//g;
	$line =~ s/\(|\)//g;
	$line =~ s/\s+$//g;
	$line =~ s/"$//g;
	$line =~ s/\s+$//g;
	
	$line =~ s/^\s+//g;

	my @words =split(/\s+/, $line);
	
	my $header = shift(@words);

	shift(@words) if($words[0] eq "\"");

	$line = join(" ", @words);
	$line =~ s/^"//g;

	print scmfile "(set! utt (utt.save.wave (utt.synth (Utterance Text \"$line\")) \"$out_dir_name/$header.wav\"))\n";
	print scmfile "(set! predicted_track (utt.feat utt \"param_track\"))\n";
	print scmfile "(track.save predicted_track (format nil \"$out_dir_name/$header.mcep\"))\n";
}
close(outfile);

