use Test2::Bundle::Extended;
use Scientist;

my $experiment = Scientist->new(
	experiment => 'Test of Context',
	use        => sub { 10 },
	try        => sub { 20 },
);

$experiment->context(
    { one_key => 'first value', second_key => 'second value' },
);

my $result = $experiment->run;

is $experiment->result->{context},
    { one_key => 'first value', second_key => 'second value' },
    'result was given context';

done_testing unless caller();
