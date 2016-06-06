#!/usr/bin/perl -w
# Usage:  addagram.pl < words.txt
# Author: somebody at ITA software.  GG?

while(<>) {
  chomp;
  my $letters = join("", sort split( //, $_ ));
  push(@{$got{$letters}}, $_);
}

$maxlen = 0;
foreach $word (sort {length($b) <=> length($a)} keys %got) {
  exit if length($word) < $maxlen;
  if (&deconstruct($word)) {
    for (my $l = $maxlen = length($word); $l>=3; $l--) {
      printf("%2d: %s\n", $l, join(',', @{$got{$solution[$l]}}));
    }
    print "\n";
  }
}

sub deconstruct {
  my($word) = @_;
  return 0 if !$got{$word};
  
  my $len = length($word);
  $solution[$len] = $word;
  return 1 if $len <= 3;
  
  for (my $l=0; $l<$len; $l++) {
    return 1 if &deconstruct(substr($word, 0, $l) . substr($word, $l+1));
  }
  return 0;
}

