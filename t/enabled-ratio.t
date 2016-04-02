use Test2::Bundle::Extended;
use Scientist;

package My::Scientist;
use parent 'Scientist';

# run the try{} case 10% of the time.
sub enabled { rand() <= 0.1 }

## no critic qw(Modules::ProhibitMultiplePackages)
package main;

my %call_counts;
my $experiment = My::Scientist->new(
    experiment => 'Ratio Test',
    use        => sub { ++$call_counts{control} },
    try        => sub { ++$call_counts{candidate} },
);

$experiment->run for 1..1000;

note 'Control called  : ', $call_counts{control};
note 'Candidate called: ', $call_counts{candidate};

is $call_counts{control}, 1000, 'Control code always ran';

ok $call_counts{candidate} >= 80 && $call_counts{candidate} <= 120,
    'Candidate code ran about 10% of the time';

done_testing;
