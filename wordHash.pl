#!/usr/bin/perl -w
# S.R. Lines   2010.08.14
# Usage:  perl -w wordHash.pl words.txt
# For debugging/quick development, set $fsUseEndDataWords = 1 below.

### prototypes
sub main_wordMute();
sub findWordsWithNoDupesInColumns($$$$$$);

### file-scoped "globals"
my  $fsUseEndDataWords = 1; # use the pre-filtered words at the END of this file
my  $fsPrintKeptWords  = 0; # print out the words used (to use for END data)
my  $fsBegSeconds   = time; # Constant;  time this script started running

##############################################################################

&main_wordMute;

sub main_wordMute() {

     # store all dictionary words in an array of hashes for fast lookup
     my ( $minSize, $maxSize, $actSize, $size ) = ( 5, 9, 0, 0 );
     my ( $rawCount, $wordCount, @sizedWords, @wordSizes ) = ( 0, 0, (), () );
     if ($fsUseEndDataWords) {
        READ: while (<DATA>) {       # use dictionary words at end of this file
            chomp;
            $rawCount++;
            $size = length($_);
            next READ if $size < $minSize || $size > $maxSize;
            if ($actSize < $size) {
                $actSize = $size;
            }
            $wordCount++;
            $sizedWords[$size]{$_} = $size;
            print  $_, "\n" if $fsPrintKeptWords;
        }
        close DATA;
    } else {
        READ: while (<>) {           # use words from STDIN ( s < words.txt )
            chomp;
            $rawCount++;
            $size = length $_;        
            next READ if $size < $minSize || $size > $maxSize;
            if ($actSize < $size) {
                $actSize = $size;
            }
            $wordCount++;
            $sizedWords[$size]{$_} = $size;
            print  $_, "\n" if $fsPrintKeptWords;
        }
        close STDIN;
    }
    exit if $fsPrintKeptWords;

    print "\nKept $wordCount of $rawCount dictionary words, lengths $minSize to $actSize.\n";

    for my $k ($minSize .. $actSize) {
        my $sizedWordsK = $sizedWords[$k];

        # 1st pass: Map sorted letter lists to all the words made from exactly those letters.  
        # That is, make a hash of hashes: the keys are the sorted lists of k-letter word letters.
        # These are lists, not sets, because a letter may be used more than once in a word.
        # The values are hashes (sets) containing just the words made from exactly those letters.
        # Keep only words that have at least 5 different letters.
        my $numWords = (keys %$sizedWordsK);
        my %lets2words = ();
        for my $word (keys  %$sizedWordsK) {
            my @letters = split //, $word;
	        my @sorted = sort(@letters);
            my $numUniqueLetters = 0;
            my $old = '@';                      # some non-letter
            for my $let (@sorted) {
                $numUniqueLetters++ if $let ne $old;
                $old = $let;
            }
            next if $numUniqueLetters < 5;
	        my $sorted = join '', @sorted;
	        $lets2words{$sorted}{$word} = 1;  # The actual value (1) is not used; use undef?
        }
        my $numLists = (keys  %lets2words);
        print "\nGot $numLists unique letters-lists from $numWords words of length $k; these ones make 5+ words:\n"; 
        
        # 2nd pass: for each letter list that forms 5 or more words,
        # look for a sub-list of 5 letters and a subset of 5 words such that
        # none of these letters appears in the same place in any two of these words.

        for my  $keyLets (sort keys  %lets2words) {
            my  $wordHash = $lets2words{$keyLets};
            my  $listSize = (keys %$wordHash);
	        if ($listSize > 4) {
                my @wordList = sort keys %$wordHash;
                &findWordsWithNoDupesInColumns(\@wordList, $keyLets, $k, 5, 5, 4);
            }
        }
    }
    print "\nEnd $0: Elapsed time: ", time - $fsBegSeconds, " seconds\n";
    exit;
}


sub findWordsWithNoDupesInColumns($$$$$$) {
    my ($wordList, $letterList, $wordLen, $numRows, $numCols, $minShow) = @_;

    my @lettersInColumn = ();       # array of hashes of letters used in each word position (column)
    my @validWords      = ();       # array of words where at least $numCols columns have no repeated letters
    my @dupesPerColumn  = ();       # array of numbers of dupes in each column
    for (1 .. $wordLen) {
        push(@dupesPerColumn, 0);   # Initialize an array of $wordLen zeros
    }
    print uc($letterList), ":  @$wordList\n" if (@$wordList > 4);

    # If we already have this letter in this column, mark this column as invalid:
    my $numValidCols = $wordLen;
    WORD: for my $word (@$wordList) {
        my $tmpValidCols = $numValidCols;
;
        my @lets = split //, $word;
        for (my $pos = 0; $pos < $wordLen; $pos++) {
            if ($lettersInColumn[$pos]{$lets[$pos]}) {      # Check if this column already has this letter
                next WORD if --$tmpValidCols < $numCols;    # Adding this word would create too many dupes
            }
        }
        # Add this word to the valid list, add its letters to the column hashes, and mark any dupes:
        for (my $pos = 0; $pos < $wordLen; $pos++) {
            if (++$lettersInColumn[$pos]{$lets[$pos]} > 1) {
                if (++$dupesPerColumn[$pos] == 1) { 
                    --$numValidCols;            # decrement count only if this column previously held no dupes
                }
            }
        }
        push( @validWords, $word );
    }
    my  $numValidWords  = @validWords;
    if ($numValidWords >= $minShow) {   # Actually, we need 5 or more words, but we'll show these...
        print "\nFound $numValidWords words forming $numValidCols columns without duplicate letters:\n";
        for my $row (@validWords) {
            my @row = split //, $row;
            printf "                @row\n";
        }
        print "                ";
        for (1 .. $wordLen) {
            print "- ";
        }
        printf "\nDuplicates:     @dupesPerColumn\n\n";
    }
}
            
# END script and begin DATA segement: previously kept words -- the ALL-CAPS "words" are for debugging only!
__END__
ABCDE
BCDEA
CDEAB
DEABC
EABCD

PQRSTU
PRSTUQ
RSTUPQ
STUPQR
TUPQRS
UPQRST

estop
pesto
opest
poets
stope
topes

ervils
livers
livres
silver
sliver
merits
mister
miters
mitres
remits
smiter
timers
enosis
eosins
essoin
noesis
noises
ossein
sonsie
estrin
inerts
insert
inters
niters
nitres
sinter
triens
trines

abiders
braised
darbies
seabird
sidebar
albites
astilbe
bastile
bestial
blastie
stabile


inserted
nerdiest
resident
sintered
trendies

partlets
platters
prattles
splatter
sprattle
assertor
assorter
oratress
reassort
roasters
respects
scepters
sceptres
specters
spectres
designer
energids
redesign
reedings
resigned

restrain
retrains
strainer
terrains
trainers
