#!/usr/local/bin/perl


sub handler{
   local ($signal) = @_;

   print "The $signal was caught  \n";
   $SIG{'INT'} = 'handler';
   &end;
   die "good enough";
}

sub end { print "The End\n"; }

# the signal array is an associative array %SIG

print "The process id is $$\n";
# ignore the HUP signal
$SIG{'HUP'} = 'IGNORE';

# set the action for  SIGBUS to default.
# $SIG{'BUS'} = 'DEFAULT';

# set usr1 handler to be handler.

$SIG{'INT'} = 'handler';

while (($key,$val) = each %SIG) {
        print $key, ' = ', $val, "\n" if $val;
    }

while (1) {
   $count++;
}

LAUGH:
    print "ha ha!\n";
