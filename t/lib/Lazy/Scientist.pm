package Lazy::Scientist;
# This Scientist only runs the try{} case 10% of the time.

use Moo;
extends 'Scientist';

sub enabled { rand() <= 0.1 };

1;
