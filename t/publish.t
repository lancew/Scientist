use Test2::Bundle::Extended;
use Scientist;

package My::Scientist;
use parent 'Scientist';

sub publish {
	my $self = shift;
    ## no critic qw(ErrorHandling::RequireCarping)
    die $self->result->{experiment};
}

## no critic qw(Modules::ProhibitMultiplePackages)
package main;
my $experiment = My::Scientist->new(
	experiment => 'Publish Test',
	use        => sub { 10 },
	try        => sub { 20 },
);

like(
	dies { $experiment->run },
    qr/Publish Test/,
    'Experiment name is in publish die statement as expected.',
);

done_testing unless caller();
