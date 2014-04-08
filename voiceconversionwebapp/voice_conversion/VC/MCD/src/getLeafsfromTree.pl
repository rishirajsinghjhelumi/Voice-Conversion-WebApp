use strict;
if($#ARGV != 1)
{
	print "Usage: perl getLefsfromTree.pl <original Tree file - infile>  <Leafs directory - outdir>\n";
	exit;
}
chomp(@ARGV);

my $unpruned_File = $ARGV[0];
my $leaf_Dir = $ARGV[1];

$leaf_Dir =~ s/\/$//g;
mkdir $leaf_Dir if(-d $leaf_Dir == 0);

`rm $leaf_Dir/*`;

open(UNPRUNED, "$unpruned_File") || die("$unpruned_File not found\n");
my $flag = 0;
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
		#my $unit = $words[0];
		my $unit = shift(@words);
		$unit =~ s/^\("|"//g;
		my $leaf_File = $leaf_Dir."/".$unit.".leaf";
		open(leaf, ">$leaf_File");
		
		if($line =~ /\)$/)
		{
			$line = join(" ", @words);
			@words = split(/\)\s+\(/, $line);
			my $tokens = "";
			for(my $i=0; $i<@words; $i++)
			{
				my @toks = split(/\s+/, $words[$i]);
				my $token = $toks[0];
				$token =~ s/\(*//g;
				$tokens = $tokens.$token."#";
			}
			$tokens =~ s/\#$//g;
			print leaf "$tokens\n";
			if($lines[$i+1] eq "))")
			{
				close(leaf);
				last;
			}
			close(leaf);
			next;
		}
		#elsif($lines[$i+1] =~ /\(\(\(/ && $lines[$i+1] =~ /(^\s+[0-9]+(\.[0-9]+)*|^\s+0)\)\)\)$/) #iiit_us_bdl voice
		elsif($lines[$i+1] =~ /\(\(\(/ && $lines[$i+1] =~ /(\s+[0-9]+(\.[0-9]+)*|\s+0)\)\)\)$/) #iiit_us_bdl voice
		{
			$i++;
			$line = $lines[$i];
			chomp($line);
			$line =~ s/^\s+//g;
			my @words = split(/\)\s+\(/, $line);
			my $tokens = "";
			for(my $i=0; $i<@words; $i++)
			{
				my @toks = split(/\s+/, $words[$i]);
				my $token = $toks[0];
				$token =~ s/\(*//g;
				$tokens = $tokens.$token."#";
			}
			$tokens =~ s/\#$//g;
			print leaf "$tokens\n";
			if($lines[$i+1] eq "))")
			{
				close(leaf);
				last;
			}
			close(leaf);
			next;
		}
		elsif($lines[$i+1] =~ /\(\(\(/)
		{
			$i++;
			my $tokens = "";
			while($lines[$i] !~ /(^\s+[0-9]+(\.[0-9]+)*|^\s+0)\)\)\)$/) #iiit_us_bdl voice
			{
				$line = $lines[$i];
				chomp($line);
				$line =~ s/^\s+//g;
				$line =~ s/^\(+//g;
				$line =~ s/\s+.*//g;
				$tokens = $tokens.$line."#";
				$i++;
			}
			$tokens =~ s/\#$//g;
			print leaf "$tokens\n";
			if($lines[$i+1] eq "))")
			{
				close(leaf);
				last;
			}
			close(leaf);
			next;
		
		}						
		elsif($lines[$i+1] =~ /\(\(/)
		{			
			while($lines[$i+1] !~ /\("/)
			{
				while($lines[$i+1] !~ /\(\(\(/)
				{
					$i++;
				}
				my $tokens = "";
				while($lines[$i+1] !~ /(^\s+[0-9]+(\.[0-9]+)*|^\s+0)\)\)/)
				{
					$i++;
					$line = $lines[$i];
					chomp($line);
					$line =~ s/^\s+//g;
					$line =~ s/^\(+//g;
					$line =~ s/\s+.*//g;
					$tokens = $tokens.$line."#";
				}
				$tokens =~ s/\#$//g;
				print leaf "$tokens\n";
				$i++;
				if($lines[$i+1] =~ /^\)\)$/)
				{
					close(leaf);
					last;
				}
			}			
			close(leaf);
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
