package src::functions;
use POSIX;
require Exporter;
#use strict qw(vars);
#use vars qw(@ISA @EXPORT $VERSION $WIN32CONSOLE);
@ISA = qw(Exporter);
@EXPORT = qw(verify readFile wav2Ascii wav2AsciiFromTo cleanDirs creatDirs writeFile loadHashTable getFeatureVectors getF0Vectors addHeader isNumber getFileCount changeremoveFeatBin changeremoveFeat normalizeFile Trim leftTrim rightTrim setIndex getIndex createParameterFile getNunberofbits dec2bin setZeros bin2dec pow convert2bin getMaxIndex getAverage getSum dec2binArray getVariance getPhoneDurations printHashTable getNextContext getPreviousContext createListFile log10 antilog getBaseName shiftN verifyFeatures);

sub verifyFeatures
{
	my $features = shift;
	my $length = shift;

	my @words = split(/\s+/, $features);

	if(@words != $length)
	{
		print "Features: $features\n";
		print "Number of features are ".@words." and actual features should be $length\n";
		return 0;	
	}
	return 1;

}
sub shiftN
{
	my $cnt = $_[1];
	my @out_lines;
	for(my $i=0; $i<$cnt; $i++)
	{
		push(@out_lines, shift(@{$_[0]}));
	}
	return @out_lines;
}
sub getBaseName
{
	my $path = shift;
	my $ext = shift;

	my $fname;
	if($ext ne "")
	{
		$fname=`basename $path .$ext`;
	}
	else
	{
		$fname = `basename $path`;
	}
	chomp($fname);
	return $fname;
}

sub log10
{
	my $n=shift;
	return log($n)/log(10);
}
sub antilog
{
	my $n=shift;
	return 10 ** $n;
}
sub verify()
{
	print "Please press enter to continue:";<STDIN>;
}
sub createListFile
{
	my $list_file = shift;
	my @cnt = @{$_[0]};
	open(list, ">$list_file") || die("$list_file not found\n");
	print list "NoFiles: ".@cnt."\n";
	print list join("\n",@cnt);
	close(list);
}

sub createSettingFile
{
	my $file = shift;
	my $wav_dir = shift;
	my $feat_dir = shift;
	open(file, ">$file") || die("$file can't be created\n");
	
	print file "WaveDir: $wav_dir\n";
	print file "HeaderBytes: 44\n";
	print file "SamplingFreq: 16000\n";
	print file "FrameSize: 64\n";
	print file "FrameShift: 64\n";
	print file "Lporder: 12\n";
	print file "CepsNum: 16\n";
	print file "FeatDir: $feat_dir\n";
	print file "Ext: .wav\n";
	close(file);
		
}
sub getPhoneDurations
{
	my $file = shift;
	my @lab_lines;
	(my $prev_time, my $temp, my $prev_unit) = qw(0 0 0);
	my @lines = &readFile($file);
	shift(@lines);
	foreach my $line(@lines)
	{
		$line =~ s/^\s+//g;
		(my $cur_time, $temp, my $cur_unit) = split(/\s+/, $line);
		push(@lab_lines, "$cur_unit $prev_time $cur_time");
		$prev_time = $cur_time;
	}	
	return @lab_lines;
}
sub printHashTable
{
	my $file = shift;
	my $hash = shift; #%hashvariable
	my $pat = " ";
	if(@_ == 1)
	{
		$pat = shift;
	}
	open(file, ">$file") || die("$file can't be created\n");
	while((my $key, my $value) = each(%{$hash}))
	{
		print file "$key$pat$value\n";
	}
	close(file);
	
}

sub readFile 
{
	my $file = shift;
	open(file, "$file") || die("$file not found\n");
	my @lines = <file>;
	chomp(@lines);
	close(file);
	return @lines;
}
sub getVariance
{
	my $sumall = 0;
	my $sumsqall = 0;
	#my @sum;
	#my @sumX;
	my $mean =0;
	my $variance = 0;
	my $count = scalar(@{$_[0]});
	return 1 if($count == 1);
	for(my $i=0; $i<@{$_[0]}; $i++)
	{
		$sumall = $sumall + ${$_[0]}[$i];
		$sumsqall = $sumsqall + ( ${$_[0]}[$i] * ${$_[0]}[$i] );
		#$sum[$i] = ${$_[0]}[$i];
		#$sumX = ${$_[0]}[$i] * ${$_[0]}[$i];
	}
	$mean = $sumall / $count;
	$variance = ( ($count * $sumsqall) - ($sumall * $sumall) ) / ($count * ($count - 1));
	return $variance;
}
sub wav2AsciiFromTo
{
	my $inf = shift;
	my $start = shift;
	my $end = shift;
	my $normalize = shift;
	my $bps = 2;
	my $header = 44;
		
	$start = $start * 16000 * 2;
	$end = $end * 16000 * 2;
	my $cnt = $end - $start;
	open(infile, "$inf") || die("$inf not found\n");
	binmode(infile);
	seek(infile, $start + $header, 0);
	my $tmp = 0;
	my @sams;
	while(read(infile, $buff, $bps))
	{
		if($tmp < $cnt)
		{
  			my $val = unpack('s', $buff);
			$val = sprintf("%.6f", $val / 65536) if($normalize == 1);
			
			push(@sams, $val);
			$tmp = $tmp + 2;
		}
	}
	close(infile);
	return @sams;
}

sub wav2Ascii()
{
	my $inf = shift;
	my $outf = shift;
	my $header = 44;
	my $bps = 2;
	open(file, "$inf") || die("$inf not found\n");
	if($outf ne "")
	{
		open(out, "$outf") || die("$outf can't be created\n");
	}
	binmode(inf);
	seek(file, $header,0);
	my $buff;
	my @samps;
	while(read(file, $buff, $bps))
	{
  		my $val = unpack('s', $buff);
		if($outf ne "")
		{
			print out "$val\n";
		}
		push(@sams, $val);
	}
	close(file);
	close(out);
	return @sams;
}
sub cleanDirs
{
	for(my $i=0; $i<@_; $i++)
	{
		$_[$i] =~ s/\/$//g;
	}
}

sub creatDirs
{
	for(my $i=0; $i<@_; $i++)
	{
		if(-d $_[$i] == 0)
		{
			mkdir $_[$i];
		}
		else
		{
			my $cnt = `ls $_[$i] | wc -l | awk '{print \$1}'`;
			chomp($cnt);
			if($cnt > 0)
			{
				`rm $_[$i]/*.*`;
			}
		}
	}
		
}
sub writeFile
{
	#usage: writeFile(<filenmae> <features - inarray> <header option [0/1] 0-without, 1-with header>);
	my $file = shift;
	my $features = shift;
	
	my $header = 0;
	if(@_ == 1)
	{
		$header = shift;;
	}
	chomp(@{$features});
	open(FILE, ">$file") || die("$file can't be created\n");
	if($header != 0 && $header ne "")
	{
		my $cnt = scalar(@{$features});
		my $vecSize = split(/\s+/, ${$features}[0]);
		print FILE "$cnt $vecSize\n";		
	}
	print FILE join("\n", @{$features})."\n";
	close(FILE);
	#&addHeader($file);
}
sub loadHashTable
{
	my $exp = "";
	if(@_ == 2)
	{
		$exp = "\\s+";
	}
	else
	{
		$exp = $_[2];
	}
	open(CAT, "$_[0]") || die("$_[0] File not found\n");
	my $flag = 0;
	foreach my $cat(<CAT>)
	{
		chomp($cat);
		if($cat =~ /^EST_File/)
		{
			$flag = 1;
		}
		if($cat =~ /^EST_Header/)
		{
			$flag = 0;
			next;
		}
		next if($flag == 1);
		my @words = split(/$exp/, $cat);
		my $key = shift(@words);
		${$_[1]}{$key} = join(" ", @words);	
	}
}
sub getFeatureVectors
{
        my $fname = shift;
        my $start = shift;
        my $end = shift;
        my $framedur = shift;
	my $features = shift;
	
        $start = floor(sprintf("%.3f", $start) * 1000 / $framedur);
        $end = floor(sprintf("%.3f", $end) * 1000 / $framedur);
        $end = $end + 1 if($end == $start);
        my $no_frames = $end - $start;
        #print "$fname $start $end $no_frames"; <STDIN>;
        open(FILE, $fname) || die("$fname not found in getFeatureVectors");
        my @lines = <FILE>;
	#shift(@lines); #used to remove the header of the file
	$lines[0] =~ s/^ //g;
	my @head = split(/\s+/, $lines[0]);
	my @nextline = split(/\s+/, $lines[1]);
	shift(@lines) if(@head != @nextline);		
			
        chomp(@lines);
        while($start < $end)
        {
		$lines[$start] =~ s/^\s+//g;
		#print $lines[$start]."\n";
		push(@{$features}, $lines[$start]);
                $start++;
        }
}
sub getF0Vectors
{
        my $fname = shift;
        my $start = shift;
        my $end = shift;
        my $framedur = shift;
	my $features = shift;
	
        $start = floor($start * 1000 / $framedur);
        $end = floor($end * 1000 / $framedur);
        $end = $end + 1 if($end == $start);
        my $no_frames = $end - $start;
        #print "$fname $start $end $no_frames"; <STDIN>;
        open(FILE, $fname) || die("$fname not found in getFeatureVectors");
        my @lines = <FILE>;
	#shift(@lines); #used to remove the header of the file
	$lines[0] =~ s/^ //g;
	my @head = split(/\s+/, $lines[0]);
	my @nextline = split(/\s+/, $lines[1]);
	shift(@lines) if(@head != @nextline);		
			
        chomp(@lines);
        while($start < $end)
        {
		$lines[$start] =~ s/^\s+//g;
		my @words = split(/\s+/, $lines[$start]);
		push(@{$features}, $words[0]);
                $start++;
        }
}
sub getSum
{
	my $sum = 0;
	#my $len = scalar(@{$_[0]});
	
	for(my $i=0; $i<@{$_[0]}; $i++)
	{
		$sum = $sum + ${$_[0]}[$i];
	}
	#print "Sum: $sum\n";
	return $sum;
}
sub getAverage
{
	my $average =0;
	my $sum = 0;
	#my $len = scalar(@{$_[0]});
	
	for(my $i=0; $i<@{$_[0]}; $i++)
	{
		$sum = $sum + ${$_[0]}[$i];
	}
	#print "Sum: $sum\n";
	$average = $sum/scalar(@{$_[0]});
	return $average;
}
sub addHeader
{
	my $file = shift;
	die("$file not found in addHeder function") if(-f $file == 0);
	my $lines = `wc -l $file | awk '{print \$1}'`;
	chomp($lines);
	my $words = `head -1 $file | wc -w`;
	chomp($words);
	`echo $lines $words > header.txt`;
	`mv $file tempfile.txt`;
	`cat header.txt tempfile.txt > $file`;
	`rm header.txt tempfile.txt`;	
}
sub isNumber
{
	my $value = shift;
	if($value =~ /^\d+(\.\d+)*$/)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}
sub getFileCount
{
	my $fname = shift;
	die("$fname not found in getFileCount function") if(-f $fname == 0);
	my $lines = `wc -l $file | awk '{print \$1}'`;
	chomp($lines);
	return $lines;
}
sub changeremoveFeatBin
{
	#Input: Features string, mapping file, description file
	my $feat = $_[0];
	my $mapfile = $_[1];
	my $descfile = $_[2];
	&loadHashTable($mapfile, \%hashmap);
	&loadFeatandMax($descfile, \%hashfet, \%hashmax);	
	my @words = split(/\s+/, $feat);
	my @maxvalues;
	my $j = 0; #used for incrementing the value as soon as one element deleted from the list.
	for(my $i=0; $i<@words; $i++)
	{
		my $key = $i + $j;
		if($hashfet{$key} == 0)
		{
			splice(@words, $i, 1);
			$j++;
			$i--;
		}
		else
		{
			push(@maxvalues, $hashmax{$key});
		}
	}
	for(my $i=0; $i<@words; $i++)
	{
		my $phval=0;
		if(&isNumber($words[$i]) == 1)
		{
			$words[$i] = $words[$i];
		}
		elsif(not exists $hashmap{$words[$i]})
		{
			my @phs = split(/\s+/,&Phonification($words[$i]));
			foreach my $ph(@phs)
			{
				$phval = $phval + $hashmap{$ph};
			}
			$words[$i] = $phval;
		}
		else
		{
			$words[$i] = $hashmap{$words[$i]};
		}
	}
	&dec2binArray(\@words, \@maxvalues);	
	my $allwords = join("", @words);
	@words = split(//,$allwords);
	return @words;
}
sub changeremoveFeat
{
	my $feat = $_[0];
	my $mapfile = $_[1];
	my $descfile = $_[2];
	&loadHashTable($mapfile, \%hashmap);
	&loadHashTable($descfile, \%hashfet);
	my @words = split(/\s+/, $feat);
	my $j = 0; #used for incrementing the value as soon as one element deleted from the list.
	for(my $i=0; $i<@words; $i++)
	{
		my $key = $i + $j;
		if($hashfet{$key} == 0)
		{
			splice(@words, $i, 1);
			$j++;
			$i--;
		}
	}
	for(my $i=0; $i<@words; $i++)
	{
		my $phval=0;
		if(&isNumber($words[$i]) == 1)
                {
                        $words[$i] = $words[$i];
                }
		elsif(not exists $hashmap{$words[$i]})
		{
			my @phs = split(/\s+/,&Phonification($words[$i]));
			foreach my $ph(@phs)
			{
				$phval = $phval + $hashmap{$ph};
			}
			$words[$i] = $phval;
		}
		else
		{
			$words[$i] = $hashmap{$words[$i]};
		}
	}
	return @words;
}
sub loadFeatandMax
{
	my $file = shift;
	$hashfet = shift;
	$hashmax = shift;
	open(CON, "$file") || die("$file not found in the loadFeatandMax function\n");
	foreach my $con(<CON>) #storing the fetures information which are required and which are not
	{
		chomp($con);
		(my $key, my $name, my $value, my $max) = split(/\s+/, $con);
		${$hashfet}{$key} = $value;
		${$hashmax}{$key} = $max;
	}
}
sub dec2binArray
{
	my @words = @{$_[0]};
	my @maxvalues = @{$_[1]};
	for(my $i=0; $i<@{$_[0]}; $i++)
	{
		my $pat = "%0".$maxvalues[$i]."b";
		${$_[0]}[$i] = sprintf($pat, ${$_[0]}[$i]);
	}
}
sub normalizeFile
{
	my $file = shift;
	die("$file not found in the normalizeFile") if(-f $file == 0);	
	my @max_words;
	my $sen = `head -2 $file | tail -1`;
	chomp($sen);
	my $len = scalar(split(/\s+/, $sen));
	for(my $i=0; $i<$len; $i++)
	{
		my $j = $i + 1;
		$max_words[$i] = abs(`cat $file | awk '{print \$$j}' | sort -n -k 1 -r | head -1`);
		#print $max_words[$i];<STDIN>;
	}
	open(FILE, "$file");
	open(NORM, ">normalize.txt");
	foreach my $line(<FILE>)
	{
		chomp($line);
		my @words = split(/\s+/, $line);
		next if(@words != $len);
		for(my $i=0; $i<@words; $i++)
		{
			$words[$i] = sprintf("%.5f", $words[$i] / $max_words[$i]);
		}
		print NORM join(" ", @words)."\n";
	}
	close(NORM);
	close(FILE);
	`cp normalize.txt $file`;
	`rm normalize.txt`;
	return join(" ", @max_words);
}
sub NormalizenAverage
{
	my $array = shift; #pointer if input array
	open(TEMP, ">tempfile.txt");
	print TEMP join("\n", @{$array});
	close(TEMP);
	&nomralizeFile("tempfile.txt");
	my @features;
	open(TEMP, "tempfile.txt") || die("tempfile.txt file not found\n");
	my $vecSize = `head -1 tempfile.txt | wc -w`;
	chomp($vecSize);
	foreach my $feature(<TEMP>)
	{
		
	}
	
}

sub Trim
{
	my $input = shift;
	my $exp = shift;
	$input =~ s/$exp//g;
	return $input;
}

sub leftTrim
{
	my $input = shift;
	my $exp = shift;
	$exp = "^".$exp;
	$input =~ s/$exp//g;
}
sub rightTrim
{
	my $input = shift;
	my $exp = shift;
	$input =~ s/$exp$//g;
}
sub setIndex
{
	my $file = shift;
	die("$file file not foundin getIndex\n") if(-f $file == 0);
	my $value = shift;
	$value = 1 if($value eq "");
	`echo $value > $file`;
}
sub getIndex
{
	my $file = shift;
	die("$file file not foundin getIndex\n") if(-f $file == 0);
	my $index = `head -1 $file`;
	chomp($index);
	return $index;
}
sub createParameterFile
{
        my $file = shift;
	die("$file not found in createParameterFile\n") if(-f $file==0);
	my $nLayers = shift;
	my $oLayer = shift;
        my $inputSize = shift;
        my $layerString = shift; 
        open(PARAM, ">$file");
        print PARAM "$nLayers\n$oLayer\n$inputSize\n$layerString\n0.01";
        close(PARAM);
}
sub getNunberofbits
{
	my $num = shift;
	my $div;
	my @bits;
	while($num != 1)
	{
		$div = $num % 2;
		$num = $num / 2;
		push(@bits, $div);
	}
	return scalar(@bits)+1;
}
sub dec2bin
{
	my $num = shift;
	my $max = shift;
	my $pat = "%0".$max."b";
	return sprintf($pat, $num);
}
sub setZeros
{
	my $len = $_[1];
	for(my $z=0; $z<$len; $z++)
	{
		${$_[0]}[$z] = 0;
	}
}
sub bin2dec
{
	my $bits = shift;
	my @words = split(//, $bits);
	@words = reverse(@words);
	my $sum = 0;
	for(my $i=0; $i<@words; $i++)
	{
		$sum = $sum + &pow(2, $i) if($words[$i] == 1);		
	}
	return $sum;
}
sub pow
{
        my $a = shift;
        my $b = shift;
	return 1 if($b == 0);
        my $out = $a;
        for(my $p=1; $p<$b; $p++)
        {
                $out = $out * $a;
        }
        return $out;
}
sub convert2bin
{
	my $line = $_[0];
	my $threshold = 0.5;
	$threshold = $_[1] if(@_ == 2);
	
	my @words =split(/\s+/, $line);
	my $bits="";
	foreach my $word(@words)
	{
		if($word > $threshold)
		{
			$bits = $bits."1";
		}
		else
		{
			$bits = $bits."0";

		}
	}
	return $bits;
}

sub getMaxIndex
{
	my $input = shift;
	my @values = split(/\s+/, $input);
	my $max = $values[0];
	my $index = -1;
	for(my $i=0; $i<@values; $i++)
	{
		if($max < $values[$i])
		{
			$max = $values[$i];	
			$index = $i;
		}
	}
	return $index;
}
sub getPreviousContext
{
	my $array = shift;
	my $win_size = shift;
	my $cur_pos = shift;
	my $features = "";
	for(my $i=$win_size; $i>0; $i--)
	{
		if($cur_pos - $i < 0)
		{
			$features .= "# ";
			next;
		}
		$features .= ${$array}[$cur_pos - $i]." ";
	}
	$features =~ s/\s+$//g;
	my @words = split(/\s+/, $features);
	$features .= " ";
	if(@words != $win_size)
	{
		my $len = scalar(@words);
		for(my $i= $len; $i<$win_size; $i++)
		{
			$features .= "# ";
		}
	}
	$features =~ s/\s+$//g;
	return $features;
}

sub getNextContext
{
	my $array = shift;
	my $win_size = shift;
	my $cur_pos = shift;
	my $features = "";
	for(my $i=1; $i<=$win_size && $i < @{$array}; $i++)
	{
		$features .= ${$array}[$cur_pos + $i]." ";
	}
	$features =~ s/\s+$//g;
	my @words = split(/\s+/, $features);
	$features .= " ";
	if(@words != $win_size)
	{
		my $len = scalar(@words);
		for(my $i= $len; $i<$win_size; $i++)
		{
			$features .= "# ";
		}
	}
	$features =~ s/\s+$//g;
	return $features;
}
