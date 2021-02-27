package Scientist::Result;

use Scientist::Player;
use Moo;
use Types::Standard qw/Bool Object Str/;

# VERSION

has 'context'     => (is => 'ro');
has 'observation' => (is => 'ro');
has 'experiment'  => (is => 'ro', isa => Str);
has 'candidate'   => (is => 'ro', isa => Object);
has 'control'     => (is => 'ro', isa => Object);
has 'matched'     => (is => 'ro', isa => Bool);
has 'mismatched'  => (is => 'ro', isa => Bool);

around BUILDARGS => sub {
    my ($orig, $class, $args) = @_;

    foreach my $key (qw(control candidate)) {
        if (exists $args->{$key}) {
            $args->{$key} = Scientist::Player->new($args->{$key});
        }
    }

    return $class->$orig($args);
};

1;

=head1 NAME

Scientist::Result - Represent the test result.

=head1 DESCRIPTION

The user can make use of the object C<Scientist::Result> in their own method C<publish()>.

=head1 METHODS

=head2 BUILDARGS()

B<FOR INTERNAL USE ONLY>

=head2 context()

Returns the context of the run.

=head2 observation()

Returns the observation of the run.

=head2 experiment()

Returns the experiment details.

=head2 candidate()

Returns object of type L<Scientist::Player>.

=head2 control()

Returns object of type L<Scientist::Player>.

=head2 matched()

Returns matched count.

=head2 mismatched()

Returns mismatched count.

=head1 LICENSE

This software is Copyright (c) 2016 by Lance Wicks.

This is free software, licensed under:

  The MIT (X11) License

The MIT License

Permission is hereby  granted, free of charge, to  any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in the
Software without restriction, including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
and to permit persons to whom the Software is furnished to do so, subject to the
following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
USE OR OTHER DEALINGS IN THE SOFTWARE.
