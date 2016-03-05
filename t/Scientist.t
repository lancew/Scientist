use strict;
use warnings;

use Scientist;

use Test::More;

my $experiment = Scientist->new( experiment => 'MyTest' );

sub old_code {
    return 10;
}

sub new_code {
    return 20;
}

$experiment->use( \&old_code );
$experiment->try( \&new_code );

my $result = $experiment->run;
is $result, 10, 'Returns the result of the "use" code';
is $experiment->result->{'mismatched'}, 1,
    'Correctly identified a mismatch between control and candidate';

is $experiment->result->{observation}{candidate}, 20, 'Observation Candidate data correct';
is $experiment->result->{observation}{control},   10, 'Observation Control data correct';

like $experiment->result->{observation}{diagnostic},
     qr/got : '20'/,
     'Observation diagnostic correct';

$experiment->use( \&old_code );
$experiment->try( \&old_code );

$result = $experiment->run;
is $experiment->result->{mismatched}, 0,
    'Correctly identified a match between control and candidate';
is $experiment->result->{experiment}, 'MyTest',
    'Experiment (name of experiment) returned in results';

# Do we have timing data
ok $experiment->result->{control}{duration},
    'Returns duration timing of control';
ok $experiment->result->{candidate}{duration},
    'Returns duration timing of candidate';
done_testing unless caller();
