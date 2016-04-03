package Publishing::Scientist;
# This Scientist knows how to publish! Shame he's not very good at it...

use Moo;
extends 'Scientist';

sub publish {
    my $self = shift;
    ## no critic qw(ErrorHandling::RequireCarping)
    die $self->result->{experiment};
}

1;
