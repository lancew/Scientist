use strict;
use warnings;

use Scientist;

use Test::More;
use Test::MockObject;

my $test_thing = Test::MockObject->new;
$test_thing->set_true('control');
$test_thing->set_true('candidate');

my $experiment = Scientist->new( experiment => 'MyTest' );

$experiment->use( sub { $test_thing->control } );
$experiment->try( sub { $test_thing->candidate } );

my %results = ( candidate => 0, control => 0 );
for ( 1 .. 1000 ) {
    my $test       = $experiment->run;
    my $first_call = $test_thing->next_call();
    $results{$first_call}++;
    $test_thing->clear();
}

note 'Control called first  :', $results{control};
note 'Candidate called first:', $results{candidate};

ok $results{control} > 450,   '>40% Control code run first';
ok $results{candidate} > 450, '>40% Candidate code run first';

done_testing();
