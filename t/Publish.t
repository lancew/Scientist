use strict;
use warnings;

use Scientist;

use Test::More;

package My::Scientist;
use parent 'Scientist';

sub publish {
    my $self = shift;
    use Data::Dumper;
    die $self->result->{experiment};
}

package main;
my $experiment = My::Scientist->new( experiment => 'Publish Test' );

sub old_code {
    return 10;
}

sub new_code {
    return 20;
}

$experiment->use( \&old_code );
$experiment->try( \&new_code );

my $result = eval { $experiment->run };
my $string = $@;
chomp $string;
is $string, 'Publish Test at t/Publish.t line 13.', 'All keys present';

done_testing unless caller();
