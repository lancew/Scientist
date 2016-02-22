package Scientist;

use strict;
use warnings;

use Moo;
use Test::Deep::NoTest 'eq_deeply';
use Time::HiRes 'time';

# ABSTRACT: Perl module inspired by https://github.com/github/scientist
# https://github.com/lancew/Scientist

# TODO: Should limit to a hashref
has 'context' => ( is => 'rw' );

has 'enabled' => ( is => 'rw', default => 1 );

has 'experiment' => ( is => 'rw' );

has 'use' => ( is => 'rw' );

has 'result' => ( is => 'rw', );

has 'try' => ( is => 'rw' );

sub publish {
    my $self = shift;
    # Stub publish sub, extend this to enable your own own
    # unique publishing requirements
    return;
}

sub run {
    my $self = shift;

    # If experiement not enabled just return the control code results.
    return $self->use->() unless $self->enabled;

    my %result = (
        context    => $self->context,
        experiment => $self->experiment,
    );

    my $wantarray = wantarray;
    my $start     = Time::HiRes::time;

    my @control = $wantarray ? $self->use->() : scalar $self->use->();

    $result{control}{duration} = Time::HiRes::time - $start;

    $start = Time::HiRes::time;

    my @candidate = $wantarray ? $self->try->() : scalar $self->try->();

    $result{candidate}{duration} = Time::HiRes::time - $start;

    $result{mismatched} = !eq_deeply( \@candidate, \@control ) ? 1 : 0;

    $self->result( \%result );
    $self->publish;

    return $wantarray ? @control : $control[0];
}

1;

=head1 LICENSE

This software is Copyright (c) 2016 by Lance Wicks.

This is free software, licensed under:

  The MIT (X11) License

The MIT License

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software
without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to
whom the Software is furnished to do so, subject to the
following conditions:

The above copyright notice and this permission notice shall
be included in all copies or substantial portions of the
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT
WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE AND NONINFRINGEMENT. IN NO EVENT
SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
