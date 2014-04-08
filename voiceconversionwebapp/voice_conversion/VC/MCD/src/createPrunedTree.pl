use strict;
if($#ARGV != 2)
{
	print "Usage: perl createPrunedTree.pl <Selected units directory - input> <unpruned file - input> <puned file - output>\n";
	exit;
}
chomp(@ARGV);

my $selected_Dir = $ARGV[0];
my $unpruned_File = $ARGV[1];
my $pruned_File = $ARGV[2];

$selected_Dir =~ s/\/$//g;

open(UNPRUNED, "$unpruned_File") || die("$unpruned_File not found\n");
open(PRUNED, ">$pruned_File") || die("$pruned_File can't be created\n");
my $flag = 0;
my @units;
#foreach my $line(<UNPRUNED>)
my @lines = <UNPRUNED>;
for(my $i=0; $i<@lines; $i++)
{
	my $line = $lines[$i];
	chomp($line);
	if($line =~ /\(set! clunits_selection_trees/)
	{
		$flag = 1;
		print PRUNED $line."\n";
		next;
	}
	if($flag == 0)
	{
		print PRUNED $line."\n";
	}
	if($line =~ /\("/)
	{
		my @words = split(/\s+/, $line);
		my $unit = $words[0];
		$unit =~ s/^\("|"//g;
		if($line =~ /\)$/)
		{
			my $file = $selected_Dir."/".$unit.".txt";
			my $index = `head -1 $file`;
			chomp($index);
			$index = 0 if($index =~ /^$/ or $index eq "");
			if($index =~ /\s+/)
			{
				$index = &getIndexUnits($index);
				print PRUNED "$words[0] (((($index 0)))\n";
			}
			else
			{
				print PRUNED "$words[0] (((($index 44.456)) 0)))\n"; 
			}
			if($lines[$i+1] eq "))\n")
			{
				print PRUNED "))";
				last;
			}
		}
		#elsif($lines[$i+1] =~ /\(\(\(/ && $lines[$i+1] =~ /(^\s+[0-9]+(\.[0-9]+)*|^\s+0)\)\)\)$/) #iiit_us_bdl voice
		elsif($lines[$i+1] =~ /\(\(\(/ && $lines[$i+1] =~ /(\s+[0-9]+(\.[0-9]+)*|\s+0)\)\)\)$/) #iiit_us_bdl voice
		{
			$i++;
			my $file = $selected_Dir."/".$unit.".txt";
			my $index = `head -1 $file`;
			chomp($index);
			$index = 0 if($index =~ /^$/ or $index eq "");
			if($index =~ /\s+/)
			{
				$index = &getIndexUnits($index);
				print PRUNED "$words[0] (((($index 0)))\n";
			}
			else
			{
				print PRUNED "$words[0] (((($index 44.456)) 0)))\n"; 
			}
			if($lines[$i+1] eq "))\n")
			{
				print PRUNED "))";
				last;
			}
			
		}
		elsif($lines[$i+1] =~ /\(\(\(/)
		{
			$i++;
			while($lines[$i+1] !~ /(^\s+[0-9]+(\.[0-9]+)*|^\s+0)\)\)\)$/) #iiit_us_bdl voice
			{
				$i++;
			}
			my $file = $selected_Dir."/".$unit.".txt";
			my $index = `head -1 $file`;
			chomp($index);
			$index = 0 if($index =~ /^$/ or $index eq "");
			if($index =~ /\s+/)
			{
				$index = &getIndexUnits($index);
				print PRUNED "$words[0] (((($index 0)))\n";
			}
			else
			{
				print PRUNED "$words[0] (((($index 44.456)) 0)))\n"; 
			}
			if($lines[$i+2] eq "))\n")
			{
				print PRUNED "))";
				last;
			}
		
		}						
		elsif($lines[$i+1] =~ /\(\(/)
		{			
			my $file = $selected_Dir."/".$unit.".txt";
			open(FILE, "$file") || die("$file not found\n");
			print PRUNED "$words[0]\n";
			while($lines[$i+1] !~ /\("/)
			{
				while($lines[$i+1] !~ /\(\(\(/)
				{
					$i++;
					print PRUNED $lines[$i];
				}
				my $pattern = $lines[$i+1];
				my $spaces = $lines[$i+1];
				$pattern =~ s/\(\([0-9]+\s+[0-9]+\.*[0-9]+\)*$//g;
				#$spaces =~ s/\(.*$//g;
				chomp($pattern);

				while($lines[$i+1] !~ /(^\s+[0-9]+(\.[0-9]+)*|^\s+0)\)\)/)
				{
					$i++;
				}
				my $index = <FILE>;
				chomp($index);
				chomp($spaces);
				if($index =~ /\s+/)
				{
					$index = &getIndexUnits($index);
					print PRUNED "$pattern(($index \n$lines[$i+1]";
				}
				else
				{
					print PRUNED "$pattern(($index 44.456))\n$lines[$i+1]";
				}
				$i++;
				if($lines[$i+1] =~ /^\)\)$/)
				{
					print PRUNED "))";
					last;
				}
			}			
		}
	}
}
close(PRUNED);
close(UNPRUNED);

sub getIndexUnits
{
	my $index = shift;
	my $ret_index = "";
	my @words = split(/\s+/, $index);
	@words = sort {$a <=> $b} @words;
	for(my $i=0; $i<@words; $i++)
	{
		if($i == 0)
		{
			$ret_index = $words[0]." 44.456)\n";
			next;
		}
		elsif($i == @words-1)
		{
			$ret_index = $ret_index."       ($words[$i] 44.456))";
		}
		else
		{
			$ret_index = $ret_index."       ($words[$i] 44.456)\n";
		}
		
	}
	return $ret_index;
}
