use strict;
use src::functions;
if($#ARGV != 2)
{
	print "Usage: perl compare.pl <original> <actual> <output>\n";
	exit;
}

chomp(@ARGV);

my %hashorig;
my %hashactual;

my $out_File = $ARGV[2];
chomp($out_File);
open(out, ">$out_File") || die("$out_File can't be created\n");
&loadHashTable($ARGV[1], \%hashactual);
open(CAT, "$ARGV[0]") || die("$ARGV[1] file not found\n");


my @lines = <CAT>;
my $flag = 0;
my $prev_catalogue = "";
my $prev_stored = "";
$prev_catalogue = $lines[5];
chomp($prev_catalogue);
my $cnt = 0;
foreach my $line(@lines)
{
	chomp($line);
	if($line =~ /EST_File/)
	{
		$flag = 1;
	}
	if($line =~ /EST_Header/)
	{
		print out "$line\n";
		$flag = 0;
		next;
	}
	print out "$line\n" if($flag == 1);
	my @words = split(/\s+/, $line);
	my $key = shift(@words);
	if(exists $hashactual{$key})
	{
		print out "$prev_catalogue\n" if($prev_catalogue ne $prev_stored); #to avoid the duplicates in the catalogue file
		#print out "$prev_catalogue\n";
		print out "$line\n";
		$prev_stored = $line;
		$cnt++;
	}
	$prev_catalogue = $line;
}
print "Total number of units: $cnt\n";
close(CAT);
close(out);
