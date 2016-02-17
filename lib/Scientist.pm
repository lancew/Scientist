package Scientist;

use strict;
use warnings;

use Moo;
use Test::Deep::NoTest 'eq_deeply';
use Time::HiRes 'time';

# ABSTRACT: Perl module inspired by https://github.com/github/scientist
# https://github.com/lancew/Scientist

has 'experiment' => ( is => 'rw' );

has 'use' => ( is => 'rw' );

has 'result' => ( is => 'rw', );

has 'try' => ( is => 'rw' );

sub run {
    my $self = shift;
    my %result;

    my $start   = Time::HiRes::time;
    my $control = $self->use->();
    $result{control}{duration} = ( Time::HiRes::time - $start );

    $start = Time::HiRes::time;
    my $candidate = eval { $self->try->() };
    $result{mismatched} = !eq_deeply( \$control, \$candidate ) ? 1 : 0;
    $result{candidate}{duration} = ( Time::HiRes::time - $start );

    $self->result( \%result );

    return $control;
}

1;
