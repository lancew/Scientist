package Lazy::Scientist;
# This Scientist only runs the try{} case some percentage of the time.

use Moo;
use Types::Standard qw/Num/;
extends 'Scientist';

has pct_enabled => (
    is      => 'rw',
    isa     => Num,
    default => 0,
);

my $count = 0;
sub enabled {
    my ($self) = @_;

    my $is_enabled = ++$count <= $self->pct_enabled;
    $count = 0 if $count >= 100;
    return $is_enabled;
}

1;
