use strict;
use warnings;

package Scientist;

use Moo;
use Test::Deep::NoTest;

# ABSTRACT: Perl module inspired by https://github.com/github/scientist
# https://github.com/lancew/Scientist

has 'experiment' => ( is => 'rw' );

has 'use' => ( is => 'rw' );

has 'result' => ( is => 'rw', );

has 'try' => ( is => 'rw' );

sub run {
    my $self = shift;

    my $control = $self->use->();
    my $candidate = eval { $self->try->() };
    my $mismatched = !eq_deeply( \$control, \$candidate );

    $self->result( { mismatched => $mismatched ? 1 : 0 } );

    return $control;
}

1;
