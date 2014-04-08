#!/usr/bin/perl
use strict;

my $nargs = $#ARGV + 1;
if ($nargs != 5) {
   print "pass <prmpF> <inD> <inE> <ouD> <ouE>\n";
   exit;
}
my $pmpF = $ARGV[0];
my $inD = $ARGV[1];
my $inE = $ARGV[2];
my $ouD = $ARGV[3];
my $ouE = $ARGV[4];

my @pmpL = &Get_ProcessedLines($pmpF);
my $s = 0;
my $n = 0;
for (my $i = 0; $i <= $#pmpL; $i++) {
  my @tw = &Get_Words($pmpL[$i]);
  my $pid = $tw[1];
  print "Processing $pid\n";
 
  my $inF = $inD."/".$pid.".".$inE;
  my $ouF = $ouD."/".$pid.".".$ouE;
  my @ra = &com_mcd($inF, $ouF);
  $s = $s + $ra[0];
  $n = $n + $ra[1];
}

my $mcd = $s / $n;
printf "final mcd is %-10.4f\n", $mcd;

sub com_mcd() {
 my $hypF = shift(@_);
 my $actF = shift(@_);

 my @hypL = &Get_ProcessedLines($hypF);
 my @actL = &Get_ProcessedLines($actF);
 my $min = $#hypL;

 if ($#hypL != $#actL) {
   print "No. of vectors $#hypL (hyp) and $#actL (act) do not match \n";
   print "Going with min match...\n";
   #exit;
   if ($min > $#actL) {
     $min = $#actL;
   }
 }

 #my $N = $#hypL + 1;
 my $N = $min + 1;
 my $mcd = 0;
 my $mx = 0;
 my $fac = 10.0 / log(10);
 #printf "fac is %10.4f\n", $fac;

 for (my $i = 0; $i <= $min; $i++) {
   my @h = &Get_Words($hypL[$i]);
   my @a = &Get_Words($actL[$i]);
   if ($#a != $#h) {
     print "At $i dimension $#h (hyp) and $#a (act) does not match \n";
     exit;
   } 
   my $s = 0;
   for (my $j = 0; $j <= $#h; $j++) {
      my $d = $h[$j] - $a[$j];
      $s = $s + ($d * $d);
   }
   $s = $fac * sqrt(2 * $s);
   $mcd = $mcd + $s;
   $mx = $mx + $s * $s;
 }
 my $s = $mcd;
 $mcd = $mcd / $N;
 $mx = $mx / $N - ($mcd * $mcd);
 printf "$N $s MCD mean %-10.4f Var: %-10.4f STD: %-10.4f \n", $mcd, $mx, sqrt($mx);
 my @ra;
 $ra[0] = $s;
 $ra[1] = $N;
 return @ra;
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

