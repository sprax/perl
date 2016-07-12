#!/usr/bin/perl
# Lifted from demerphq the chancellor: http://www.perlmonks.org/?node_id=308382

use strict;
use warnings;
use Scalar::Util qw(reftype refaddr);

my @array1 = ( 1 .. 10 );
my @array2 = ( qw(a b c) , [ 28, 42, 84 ] , 'foo bar' );

push @array1 , \@array2;
push @array2 , \@array1;
my %hash=(
            foo=>[qw(bar baz)],
            bar=>{ foo=>1, baz=>2},
            baz=>\@array1,
            bop=>\@array2
         );

print "   flatten:",join(', ' , flatten(\@array1 , \@array2)),"\n";
print "lr_flatten:",join(', ' , lr_flatten(\@array1 , \@array2)),"\n";
print "*  flatten:",join(', ' , flatten(\%hash)),"\n";

sub flatten {
   my @context;
   my @flat;
   my %seen;

   push @context,[0,\@_]; # index, array ref
   
   #@context could be simpler if we didnt care about 
   #destroying the arrays that we are  flattening.

   while (@context and $context[-1][0]<@{$context[-1][1]}) {
        my $item=$context[-1][1][$context[-1][0]++]; 
        my $type=reftype $item;
        unless ($type) {
            push @flat,$item;
        } elsif ($type eq 'ARRAY') {
            push @context,[0,$item]
                unless $seen{refaddr $item}++;
        } elsif ($type eq 'HASH') {
            push @context,[0,[map { $_ => $item->{$_} } 
                              sort {$a cmp $b} keys %$item]]
                unless $seen{refaddr $item}++;
        } else {
            die "Error! can only flatten scalars, ARRAYs and HASHes,".
                          " got a $type instead\n";
        }
        pop @context unless $context[-1][0]<@{$context[-1][1]};
   }
   return wantarray ? @flat : \@flat;
}

sub lr_flatten {
   my @stack = @_;
   my @flat;
   my %seen;

   $seen{$_} = 1 for @stack;

   while ( @stack ) {
       my $array = shift @stack;
       for my $element ( @$array ) {
           if ( ref $element eq 'ARRAY') {
               if ( ! $seen{$element} ) {
                   $seen{$element} = 1;
                   unshift @stack , $element;
               }
           }
           else {
               push @flat , $element;
           }
       }
   }

   return wantarray ? @flat : \@flat;
}

