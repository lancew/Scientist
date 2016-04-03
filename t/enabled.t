use Test2::Bundle::Extended;
use Scientist;

my $experiment = Scientist->new(
    experiment => 'Enabled Test',
    use        => sub { 10 },
    enabled    => 0,
);

my $result = $experiment->run;
is $result, 10, 'Returns the result of the "use" code';
is $experiment->result, undef, 'Result is not set if experiment not enabled';

done_testing unless caller();
