#!/usr/bin/perl
use strict;

my $_frmSft = 0.005;

my $nargs = $#ARGV + 1;
if ($nargs != 6) {
  print "pass <prmpF> <mcepD> <tarmcePD> <labD> <mapF> <ncontext>\n";
  print "This script dumps features at every 5 ms..\n";

   exit;
}

my $prmF = $ARGV[0];
my $mcepD = $ARGV[1];
my $tmcepD = $ARGV[2];
my $labD = $ARGV[3];
my $mapF = $ARGV[4];
my $n = $ARGV[5];

my $dim = 25;
my $zero = "";
for (my $z = 0; $z < $dim; $z++) {
   $zero = $zero."0.00001 ";
}
&Make_SingleSpace(\$zero);

my @mapL = &Get_ProcessedLines($mapF);
my %mapH;
for (my $i = 0; $i <= $#mapL; $i++) {
  my @tw = &Get_Words($mapL[$i]);
  my $key = $tw[0];
  my $val = "";
  for (my $j = 1; $j <= $#tw; $j++) {
    $val = $val." ".$tw[$j];
  }
  &Make_SingleSpace(\$val);
  $mapH{$key} = $val;
  print "$key $val\n";
}

my @prmL = &Get_ProcessedLines($prmF);
for (my $i = 0; $i <= $#prmL; $i++) {
  my @tw = &Get_Words($prmL[$i]);
  my $pid = $tw[1];
  print "Processing $pid $i / $#prmL\n";
  my $mcepF = $mcepD."/".$pid.".mcep";

  my $tmcepF = $tmcepD."/".$pid.".mcep";
  my $tidF = $tmcepD."/".$pid.".paf";

  my @mcepL = &Get_ProcessedLines($mcepF);
  
  #code for downsampling...
  my @dsamp;
  #my $c = 0;
  #for (my $j = 0; $j <= $#mcepL; $j = $j + 2) {
  #   $dsamp[$c] = $mcepL[$j];
  #   $c++;
  #}
  #print "downsamples done from $#mcepL to $#dsamp\n";
  
  my @stack;
  my $n2 = 2 * $n; ##this is because of 5 ms shift...
                   ##but you want to capture 10 ms window as context.
  for (my $c = 0; $c <= $#mcepL; $c++) {
    my $cf = "";
    for (my $t = $c - $n2; $t <= $c + $n2; $t = $t + 2) {
       if ($t < 0 || $t > $#mcepL) {
         $cf = $cf." ".$zero;
       }else {
         $cf = $cf." ".$mcepL[$t];
       }
    }
    &Make_SingleSpace(\$cf);
    $stack[$c] = $cf;
  }

  open(fp_o, ">$tmcepF");
  open(fp_tid, ">$tidF");

  my $labF = $labD."/".$pid.".lab";
  my @labL = &Get_ProcessedLines($labF);
  my $bF = -1;
  my $bT = 0;
  my $tC = 0;
  for (my $t = 1; $t <= $#labL; $t++) {
    my @wrd = &Get_Words($labL[$t]);
    my $eT = $wrd[0];
    my $eF = $eT / $_frmSft; #et and $_frmSft in sec..
    $eF = int($eF);

    my $pid = $wrd[2];
 
    ##print "printing from $bF to $eF $bT $eT\n";

    for (my $k = $bF + 1; $k <= $eF; $k++) {
        if ($k > $#mcepL) {
           print "$pid $#mcepL vs $k hi vasanth\n";
           #exit;
        }
        print fp_o "$stack[$k]\n";
        if (exists $mapH{$pid}) {
           print fp_tid "$mapH{$pid}\n";
        } else {
           print "$pid entry doesn't exists or not found\n";
           exit;
        }
        #print "$mcepL[$k]\n";
        #if ($tC >=255) {
        #  print "$pid.. $mapH{$pid}\n";
        #}
        $tC++;
    }
    $bT = $eT;
    $bF = $eF;
  }
  print "total frames are: $tC\n";
  close(fp_o);
  close(fp_tid);
}

sub Make_SingleSpace() {
   chomp(${$_[0]});
   ${$_[0]} =~ s/[\s]+$//;
   ${$_[0]} =~ s/^[\s]+//;
   ${$_[0]} =~ s/[\s]+/ /g;
   ${$_[0]} =~ s/[\t]+/ /g;
}

sub Check_FileExistence() {
  my $inF = shift(@_); 
  if (!(-e $inF)) { 
    print "Cannot open $inF \n";
    exit;
  } 
  return 1;
}

sub Get_Lines() {
  my $inF = shift(@_); 
  &Check_FileExistence($inF);
  open(fp_llr, "<$inF");
  my @dat = <fp_llr>;
  close(fp_llr);
  return @dat;
}

sub Get_Words() {
  my $ln = shift(@_);
  &Make_SingleSpace(\$ln);
  my @wrd = split(/ /, $ln);
  return @wrd;
}

sub Get_ProcessedLines() {
  my $inF = shift(@_);
  &Check_FileExistence($inF);
  open(fp_llr, "<$inF");
  my @dat = <fp_llr>;
  close(fp_llr);

  my @nd;
  for (my $i = 0; $i <= $#dat; $i++) {
     my $tl = $dat[$i];
     &Make_SingleSpace(\$tl);
     $nd[$i]  = $tl;
  }
  return @nd;
}

