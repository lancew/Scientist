use Test2::Bundle::Extended;
use Scientist;

my $experiment = Scientist->new( experiment => 'Test of Context' );

sub old_code {
    return 10;
}

sub new_code {
    return 20;
}

$experiment->use( \&old_code );
$experiment->try( \&new_code );
$experiment->context(
    { one_key => 'first value', second_key => 'second value' } );

my $result = $experiment->run;

is $experiment->result->{context},
    { one_key => 'first value', second_key => 'second value' },
    'result was given context';

done_testing unless caller();
