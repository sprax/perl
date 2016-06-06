#!/usr/bin/perl -w 
# S.R. Lines   2010.01.16 
# Find the most frequent words in a text file.
# Usage:  perl -w frequenth.pl < anyFile.txt 
#####################################################################

&main_frequenth;

sub main_frequenth() {

    my $filePath      = $ARGV[0] || '';

    # store all dictionary words in an array of hashes for fast lookup
    my ( $minSize, $maxSize, $size ) = ( 2, 0, 0 );
    my ( $lineCount, $rawCount, $wordCount, %w2f, ) = ( 0, 0, 0, () );

    ### Read in the words, counting, sizing, and binning them.
    my  $FILE;
    if ($filePath) { 
        if ($filePath eq '-') {
            $FILE = STDIN;                  # use words from STDIN (  < words.txt )
        } elsif ($filePath eq 'DATA') {
            $FILE = DATA;                       # use dictionary words at end of this file
            $filePath = 0;
        } else {
            open $FILE, $filePath or die "Failed to open file: $filePath\n";
        }
    }
    
    my ($freqSize, $freqThresh, $freqCount) = (12,0,0);
    my @freqQueue = ();
    my %freqHash = ();
    READ: while (<$FILE>) {           
        chomp;
        $lineCount++;
        $size = length $_;        

        next READ if $size < $minSize;
     
        my @words = split /\W+/; 
        $rawCount += @words;
        for $word (@words) {
            $word = lc($word);
            next if length($word) < $minSize;
            $wordCount++;
            $freqCount = ++$w2f{$word};
            if ($freqCount > $freqThresh) {
                if (@freqQueue < $freqSize) {
                    if ($freqHash{$word}++ == 0) {
                        # Append word if not already in queue
                        push(@freqQueue, $word);
                        print "pushing: $word\n";
                    }
                } elsif (@freqQueue == $freqSize) {

                    # find the new place in the queue for this word, and the old place if it was already in the queue
                    my ($j, $jold) = (scalar(@freqQueue), -1);
                    while (--$j > 0) {
                        $jold = $j if ($word eq $freqQueue[$j]);        # this word already in set; may swap
                        last if ($w2f{$freqQueue[$j-1]} > $freqCount);  # the (new) place for this word will be j
                    }
                    $jold = 0 if ($j == 0 && $word eq $freqQueue[0]);
                    if ($jold > -1) {
                        # if the word was already in the queue, swap it if necessary
                        if ($jold != $j) {
                            $freqQueue[$jold] = $freqQueue[$j];
                            $freqQueue[$j] = $word;
                        }
                    } else {
                        # new word was not already in the queue, so insert it, and drop the last word
                        splice(@freqQueue, $j, 0, $word);
                        pop(@freqQueue);
                    }
                    # set threshold to the freq of the last word in the queue
                    $freqThresh = $w2f{$freqQueue[$#freqQueue]};
                }
                # printf ("      %4d %3d %s\n", $w2f{$word}, $freqThresh, $word) if ($freqCount > 95);
            }
        }
    }
    close $FILE;
    print "\nInput: kept $wordCount out of $rawCount words.\n";

    print "\n    reverse sorted list of all:\n";
    my  $count = $freqSize;
    for $word ( sort { $w2f{$b} <=> $w2f{$a} } keys %w2f) {
        printf "%4d %s\n", $w2f{$word}, $word;
        last if --$count < 0;
    }
    print "\n    freqQueue:\n";
    for $word (@freqQueue) {
        printf "%4d %s\n", $w2f{$word}, $word;
    }

}

__END__
Accordingly we went with Polemarchus to his house; and there we found
his brothers Lysias and Euthydemus, and with them Thrasymachus the
Chalcedonian, Charmantides the Paeanian, and Cleitophon the son of
Aristonymus.  There too was Cephalus the father of Polemarchus, whom I
had not seen for a long time, and I thought him very much aged.  He was
seated on a cushioned chair, and had a garland on his head, for he had
been sacrificing in the court; and there were some other chairs in the
room arranged in a semicircle, upon which we sat down by him.  He
saluted me eagerly, and then he said:--

You don't come to see me, Socrates, as often as you ought: If I were
still able to go and see you I would not ask you to come to me.  But at
my age I can hardly get to the city, and therefore you should come
oftener to the Piraeus.  For let me tell you, that the more the
pleasures of the body fade away, the greater to me is the pleasure and
charm of conversation.  Do not then deny my request, but make our house
your resort and keep company with these young men; we are old friends,
and you will be quite at home with us.

I replied:  There is nothing which for my part I like better, Cephalus,
than conversing with aged men; for I regard them as travellers who have
gone a journey which I too may have to go, and of whom I ought to
enquire, whether the way is smooth and easy, or rugged and difficult.
And this is a question which I should like to ask of you who have
arrived at that time which the poets call the 'threshold of old
age'--Is life harder towards the end, or what report do you give of it?

I will tell you, Socrates, he said, what my own feeling is.  Men of my
age flock together; we are birds of a feather, as the old proverb says;
and at our meetings the tale of my acquaintance commonly is--I cannot
eat, I cannot drink; the pleasures of youth and love are fled away:
there was a good time once, but now that is gone, and life is no longer
life.  Some complain of the slights which are put upon them by
relations, and they will tell you sadly of how many evils their old age
is the cause.  But to me, Socrates, these complainers seem to blame
that which is not really in fault.  For if old age were the cause, I
too being old, and every other old man, would have felt as they do.
But this is not my own experience, nor that of others whom I have
known.  How well I remember the aged poet Sophocles, when in answer to
the question, How does love suit with age, Sophocles,--are you still
the man you were?  Peace, he replied; most gladly have I escaped the
thing of which you speak; I feel as if I had escaped from a mad and
furious master.  His words have often occurred to my mind since, and
they seem as good to me now as at the time when he uttered them.  For
certainly old age has a great sense of calm and freedom; when the
passions relax their hold, then, as Sophocles says, we are freed from
the grasp not of one mad master only, but of many.  The truth is,
Socrates, that these regrets, and also the complaints about relations,
are to be attributed to the same cause, which is not old age, but men's
characters and tempers; for he who is of a calm and happy nature will
hardly feel the pressure of age, but to him who is of an opposite
disposition youth and age are equally a burden.

I listened in admiration, and wanting to draw him out, that he might go
on--Yes, Cephalus, I said:  but I rather suspect that people in general
are not convinced by you when you speak thus; they think that old age
sits lightly upon you, not because of your happy disposition, but
because you are rich, and wealth is well known to be a great comforter.

You are right, he replied; they are not convinced:  and there is
something in what they say; not, however, so much as they imagine.  I
might answer them as Themistocles answered the Seriphian who was
abusing him and saying that he was famous, not for his own merits but
because he was an Athenian:  'If you had been a native of my country or
I of yours, neither of us would have been famous.' And to those who are
not rich and are impatient of old age, the same reply may be made; for
to the good poor man old age cannot be a light burden, nor can a bad
rich man ever have peace with himself.

May I ask, Cephalus, whether your fortune was for the most part
inherited or acquired by you?

Acquired!  Socrates; do you want to know how much I acquired?  In the
art of making money I have been midway between my father and
grandfather: for my grandfather, whose name I bear, doubled and trebled
the value of his patrimony, that which he inherited being much what I
possess now; but my father Lysanias reduced the property below what it
is at present: and I shall be satisfied if I leave to these my sons not
less but a little more than I received.

That was why I asked you the question, I replied, because I see that
you are indifferent about money, which is a characteristic rather of
those who have inherited their fortunes than of those who have acquired
them; the makers of fortunes have a second love of money as a creation
of their own, resembling the affection of authors for their own poems,
or of parents for their children, besides that natural love of it for
the sake of use and profit which is common to them and all men.  And
hence they are very bad company, for they can talk about nothing but
the praises of wealth.  That is true, he said.

Yes, that is very true, but may I ask another question?  What do you
consider to be the greatest blessing which you have reaped from your
wealth?

One, he said, of which I could not expect easily to convince others.
For let me tell you, Socrates, that when a man thinks himself to be
near death, fears and cares enter into his mind which he never had
before; the tales of a world below and the punishment which is exacted
there of deeds done here were once a laughing matter to him, but now he
is tormented with the thought that they may be true: either from the
weakness of age, or because he is now drawing nearer to that other
place, he has a clearer view of these things; suspicions and alarms
crowd thickly upon him, and he begins to reflect and consider what
wrongs he has done to others.  And when he finds that the sum of his
transgressions is great he will many a time like a child start up in
his sleep for fear, and he is filled with dark forebodings.  But to him
who is conscious of no sin, sweet hope, as Pindar charmingly says, is
the kind nurse of his age:

    Hope, he says, cherishes the soul of him who lives in
    justice and holiness and is the nurse of his age and the
    companion of his journey;--hope which is mightiest to sway
    the restless soul of man.

How admirable are his words!  And the great blessing of riches, I do
not say to every man, but to a good man, is, that he has had no
occasion to deceive or to defraud others, either intentionally or
unintentionally; and when he departs to the world below he is not in
any apprehension about offerings due to the gods or debts which he owes
to men.  Now to this peace of mind the possession of wealth greatly
contributes; and therefore I say, that, setting one thing against
another, of the many advantages which wealth has to give, to a man of
sense this is in my opinion the greatest.

Well said, Cephalus, I replied; but as concerning justice, what is
it?--to speak the truth and to pay your debts--no more than this?  And
even to this are there not exceptions?  Suppose that a friend when in
his right mind has deposited arms with me and he asks for them when he
is not in his right mind, ought I to give them back to him?  No one
would say that I ought or that I should be right in doing so, any more
than they would say that I ought always to speak the truth to one who
is in his condition.

You are quite right, he replied.

But then, I said, speaking the truth and paying your debts is not a
correct definition of justice.

CEPHALUS - SOCRATES - POLEMARCHUS

Quite correct, Socrates, if Simonides is to be believed, said
Polemarchus interposing.

I fear, said Cephalus, that I must go now, for I have to look after the
sacrifices, and I hand over the argument to Polemarchus and the company.

Is not Polemarchus your heir?  I said.

To be sure, he answered, and went away laughing to the sacrifices.

SOCRATES - POLEMARCHUS

Tell me then, O thou heir of the argument, what did Simonides say, and
according to you truly say, about justice?

He said that the repayment of a debt is just, and in saying so he
appears to me to be right.

I should be sorry to doubt the word of such a wise and inspired man,
but his meaning, though probably clear to you, is the reverse of clear
to me.  For he certainly does not mean, as we were now saying that I
ought to return a return a deposit of arms or of anything else to one
who asks for it when he is not in his right senses; and yet a deposit
cannot be denied to be a debt.

True.

Then when the person who asks me is not in his right mind I am by no
means to make the return?

Certainly not.

When Simonides said that the repayment of a debt was justice, he did
not mean to include that case?

Certainly not; for he thinks that a friend ought always to do good to a
friend and never evil.

You mean that the return of a deposit of gold which is to the injury of
the receiver, if the two parties are friends, is not the repayment of a
debt,--that is what you would imagine him to say?

Yes.

And are enemies also to receive what we owe to them?

To be sure, he said, they are to receive what we owe them, and an
enemy, as I take it, owes to an enemy that which is due or proper to
him--that is to say, evil.

Simonides, then, after the manner of poets, would seem to have spoken
darkly of the nature of justice; for he really meant to say that
justice is the giving to each man what is proper to him, and this he
termed a debt.

That must have been his meaning, he said.

By heaven!  I replied; and if we asked him what due or proper thing is
given by medicine, and to whom, what answer do you think that he would
make to us?

He would surely reply that medicine gives drugs and meat and drink to
human bodies.

And what due or proper thing is given by cookery, and to what?

Seasoning to food.

And what is that which justice gives, and to whom?

If, Socrates, we are to be guided at all by the analogy of the
preceding instances, then justice is the art which gives good to
friends and evil to enemies.

That is his meaning then?

I think so.

And who is best able to do good to his friends and evil to his enemies
in time of sickness?

The physician.

Or when they are on a voyage, amid the perils of the sea?

The pilot.

And in what sort of actions or with a view to what result is the just
man most able to do harm to his enemy and good to his friends?

In going to war against the one and in making alliances with the other.

But when a man is well, my dear Polemarchus, there is no need of a
physician?

No.

And he who is not on a voyage has no need of a pilot?

No.

Then in time of peace justice will be of no use?

I am very far from thinking so.

You think that justice may be of use in peace as well as in war?

Yes.

Like husbandry for the acquisition of corn?

Yes.

Or like shoemaking for the acquisition of shoes,--that is what you mean?

Yes.

And what similar use or power of acquisition has justice in time of
peace?

In contracts, Socrates, justice is of use.

And by contracts you mean partnerships?

Exactly.

But is the just man or the skilful player a more useful and better
partner at a game of draughts?

The skilful player.

And in the laying of bricks and stones is the just man a more useful or
better partner than the builder?

Quite the reverse.

