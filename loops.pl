#!/usr/bin/perl -w
# S.R. Lines   2004  3/12 - 3/27
use List::Permutor;   # CPAN Algorithm::Permute might be faster,
# but the permutor must permute from the end of the list backwards
my $begSec = time;    # constant;  time when program starts
my $difSec = $begSec; # wall-clock seconds since last call to printResults
my $minWordLen =  2;  # constant for WORD.LST (and nonsensical palindromes)
my $minWordLs1 =  $minWordLen - 1;
my $maxWordLen = -1;

@nn = (1..4);
$z = 0;
print "compare\n";
for $a (@nn) {
    for $b (@nn) {
      # next if $a == $b;
        next unless $a < $b;
        printf "%2d  $a.$b\n", ++$z;
    }
}
$z = 0;
print "index\n";
for ($j = 0; $j < @nn; $j++) {
    for ($k = $j+1; $k < @nn; $k++) {
        printf "%2d  $nn[$j].$nn[$k]\n", ++$z;
    }
}
$z = 0;
print "shift\n";
while (@nn) {
    $a = shift @nn;
    for $b (@nn) {
        printf "%2d  $a.$b\n", ++$z;
    }
}

exit;

