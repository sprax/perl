#!/usr/bin/perl -w 
# Auth: Sprax Lines   
# Date: 2010 ?  Probably much earlier.

sub isprime_odd($) {
    my $number = shift;
    my $end = int($number/2);
    for my $j (3 .. $end) {    # not checking even numbers
        return 0 if $number % $j == 0;
    }
    return 1;
}

my @primes;
my ($beg, $end, $count) = ($ARGV[0], $ARGV[1], 0);
die "Usage: $0 begNum endNum\n" unless (1 < $beg && $beg < $end);

$beg++ unless $beg % 2;    # if $beg isn't odd, increment it
$end-- unless $end % 2;    # if $beg isn't odd, decrement it

for my $j ($beg .. $end) {
    $primes[$j - $beg] = 1;
}

for ($number = $beg; $number <= $end; $number += 2) {
    if (isprime_odd($number)) {
        $count++;
        printf "%3d: %3d\n", $count, $number;
    } else {
        $primes[$number - $beg] = 0;
    }
}




