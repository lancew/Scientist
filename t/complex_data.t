use Test2::Bundle::Extended;
use Scientist;

my $experiment = Scientist->new( experiment => 'MyTest' );
is $experiment->experiment, 'MyTest',
    'experiment method returns the experiment name';

sub old_code {
    return [ { foo => 1 }, { bar => 'x' } ];
}

sub new_code {
    return [ { for => 1 }, { bar => 'ZZZ' } ];
}

$experiment->use( \&old_code );
$experiment->try( \&new_code );

my $result = $experiment->run;

is $result, [ { foo => 1 }, { bar => 'x' } ],
    'Returns the result of the "use" code';
ok $experiment->result->{mismatched},
    'Correctly identified a mismatch between control and candidate';

$experiment->use( \&old_code );
$experiment->try( \&old_code );
$result = $experiment->run;
ok !$experiment->result->{mismatched},
    'Correctly identified no mismatch between control and candidate';

done_testing unless caller();
