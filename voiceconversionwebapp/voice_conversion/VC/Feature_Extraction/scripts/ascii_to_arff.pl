#!/usr/bin/perl
use strict;

my $nargs = $#ARGV + 1;
if ($nargs != 6) {
   print "pass <promptfile> <inD> <inE> <outD> <outE> <arffheaderfile>\n";
   exit;
}
my $prmpF = $ARGV[0];
my $inD = $ARGV[1];
my $inE = $ARGV[2];
my $outD = $ARGV[3];
my $outE = $ARGV[4];
my $hdrF = $ARGV[5];

my @hrdL = &Get_ProcessedLines($hdrF);

my @prmpL = &Get_ProcessedLines($prmpF);
for (my $i = 0; $i <= $#prmpL; $i++) {
   my @tw = &Get_Words($prmpL[$i]);
   my $pid = $tw[1];
   print "processing $pid\n";
   my $aF = $inD."/".$pid.".".$inE;
   my $oF = $outD."/".$pid.".".$outE;
   my @inL = &Get_ProcessedLines($aF);
   
   open(fp_o, ">$oF");
   for (my $k = 0; $k <= $#hrdL; $k++) {
      print fp_o "$hrdL[$k]\n";
   }
   for (my $j = 0; $j <= $#inL; $j++) {
      my $ln = $inL[$j];
      &Make_SingleSpace(\$ln);
      $ln =~ s/[\s]/\,/g;
      print fp_o "$ln\n";
   }
   close(fp_o);
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

