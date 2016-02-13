use strict;
use warnings;

use Scientist;

use Test::Spec;
use Test::Spec::Mocks;

describe 'A Scientist' => sub {
    my $scientist;

    before each => sub {
      $scientist = Scientist->new();
    };

    context 'simple test' => sub {
    
      it 'ok' => sub {
           ok 1;
      };
  };
};

runtests unless caller();
