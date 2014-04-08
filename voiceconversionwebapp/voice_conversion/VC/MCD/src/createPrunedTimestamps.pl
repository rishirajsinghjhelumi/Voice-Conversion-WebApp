use strict;
use src::functions;
if($#ARGV != 2)
{
	print "Usage: perl createPrunedTimestamps.pl <catalogue file> <selected units directoru - indir> <timestamps file outfile>\n";
	exit;
}

chomp(@ARGV);

my $cat_file = $ARGV[0];
my $selected_Dir = $ARGV[1];
my $time_File = $ARGV[2];

$selected_Dir =~ s/\/$//g;

`rm $time_File` if(-f $time_File);

opendir(selected, "$selected_Dir") || die("Directory doesn't exist\n");

my %hashcat;
&loadHashTable($cat_file, \%hashcat);
my @keys = keys (%hashcat);
print scalar(@keys)."\n";

foreach my $file(readdir selected)
{
	chomp($file);
	if($file =~ /\.txt$/)
	{
		my $unit = $file;
		$unit =~ s/\.txt//g;
		my $selected_File = $selected_Dir."/".$file;
		&generateTimeStamps($selected_File, $time_File, $unit);	
	}
}

sub generateTimeStamps
{
	my $selected_File = shift;
	my $time_File = shift;
	my $unit = shift;
	open(SELECTED, "$selected_File") || die("$selected_File not found\n");
	open(TIMED, ">>$time_File") || die("$time_File can't be created\n");

	foreach my $line(<SELECTED>)
	{
		chomp($line);
		my @words = split(/\s+/, $line);
		foreach my $word(@words)
		{
			my $key = $unit."_".$word;
			print TIMED "$key $hashcat{$key}\n";
		}
		#imy $key = $unit."_".$line;
		#print TIMED "$key $hashcat{$key}\n";
	}
	close(SELECTED);
	close(TIMED);
}

