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

$experiment->enabled(0);

my $result = $experiment->run;
is $result, 10, 'Returns the result of the "use" code';

is $experiment->result, undef, 'Result is not set if experiment not enabled';

done_testing unless caller();
