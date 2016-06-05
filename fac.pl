
%h = qw(one 1 two 2 three 3 four 4);
$r = \$h{'two'};
%s = ('two', \$h{'two'},  'four', \$h{'four'} );
print "\nh{two}:$h{'two'}  *r($$r)   s{two}:", ${$s{'two'}}, "\n";
$h{'two'} = 0;

print "\nh{two}:$h{'two'}  *r($$r)   s{two}:", ${$s{'two'}}, "\n";


#exit;




use List::Permutor;  # Algorithm::Permute would be faster
# Example usage:

# Utility function: factorial with memoizing
BEGIN {
  sub factorial($);
  my @fact = (1);
  sub factorial($) {
      my $n = shift;
      return 0 if $n < 0;
      return $fact[$n] if defined $fact[$n];
      $fact[$n] = $n * factorial($n - 1);
  }
}

@ww = qw(A A B C);
$n = @ww;
%uniq = ();
my $perm = new List::Permutor @ww;
while (my @set = $perm->next) {
    $ss = join '', @set;
#   next if $uniq{$ss}++;
    print "    @set\n";
}
print &factorial(scalar(@ww)), " perms\n";
exit;
