package Named::Scientist;
# This Scientist only runs the try{} case 10% of the time.

use Moo;
extends 'Scientist';

sub name { 'joe' };

1;
