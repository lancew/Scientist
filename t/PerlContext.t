use strict;
use warnings;

use Scientist;

use Test::More;

my $experiment = Scientist->new( experiment => 'Scientist Handles perl context correctly', enabled => 0);

my @a = ('one','two','three');
sub old_code {
    return wantarray ? @a : "@a";
}

sub new_code {
    return wantarray ? @a : "@a";
}

$experiment->use( \&old_code );
$experiment->try( \&new_code );

my $result = $experiment->run;
is $result, 'one two three', "Scalar context";

my @result = $experiment->run;
is_deeply \@result, ['one','two','three'], "List context";

# Test again with experiment enabled.
$experiment->enabled(1);
$result = $experiment->run;
is $result, 'one two three', "Scalar context";

@result = $experiment->run;
is_deeply \@result, ['one','two','three'], "List context";



done_testing unless caller();
