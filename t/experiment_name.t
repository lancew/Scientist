use Test2::Bundle::Extended;
use Scientist;

# Silly test for coverage:
ok Scientist::name(), 'name() returns true';

# Actual test to name() in a subclass:
package My::Scientist;
use parent 'Scientist';

sub name { "new name" }

## no critic qw(Modules::ProhibitMultiplePackages)
package main;

my $sci = My::Scientist->new;
is $sci->experiment, 'new name', "Got overriden name() via experiment()";

done_testing;
