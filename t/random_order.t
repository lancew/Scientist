use Test2::Bundle::Extended;
use Scientist;

# This is a race to see under normal conditions whether the
# control() or the candidate() is run first.
#
# Ideally, they should each win half the time.

my $winner;
my $test_thing = mock obj => (
    add => [
        control   => sub { $winner ||= 'control'   },
        candidate => sub { $winner ||= 'candidate' },
    ],
);

my $experiment = Scientist->new( experiment => 'random order test' );
$experiment->use( sub { $test_thing->control   } );
$experiment->try( sub { $test_thing->candidate } );

# Race 1000 times and record each winner.
my %results;
for (1..1000) {
    $experiment->run;
    $results{$winner}++;
    undef $winner;
}

note 'Control called first  :', $results{control};
note 'Candidate called first:', $results{candidate};

ok $results{control} > 450,   '>40% Control code run first';
ok $results{candidate} > 450, '>40% Candidate code run first';

done_testing();
