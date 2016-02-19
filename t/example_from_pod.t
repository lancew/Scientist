use strict;
use warnings;

use Scientist;
use Test::More;

sub old_code {
    return 10;
}

sub new_code {
    return 20;
}

my $experiment = Scientist->new( 
    experiment => 'MyTest',
    use => \&old_code,
    try => \&new_code,
);

my $ten = $experiment->run;


ok $experiment->result->{'mismatched'} && $ten == 10,
    'Example from POD works ok.';

done_testing unless caller();