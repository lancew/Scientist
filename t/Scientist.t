use strict;
use warnings;

use Scientist;

use Test::More;

my $experiment = Scientist->new( experiment => 'MyTest' );
is $experiment->experiment, 'MyTest',
    '->experiment Returns the experiment name';

sub old_code {
    return 10;
}

sub new_code {
    return 20;
}

$experiment->use( \old_code );
$experiment->try( \new_code );

my $result = $experiment->run;
is $result, 10, 'Returns the result of the "use" code';
is $experiment->result->{'mismatched'}, 1,
    'Correctly identified a mismatch between control and candidate';

$experiment->use( \old_code );
$experiment->try( \old_code );
$result = $experiment->run;
is $result, 10, 'Returns the result of the "use" code';
is $experiment->result->{'mismatched'}, 0,
    'Correctly identified a no mismatch between control and candidate';

done_testing unless caller();
