package RoleTest;

use strict;
use warnings;

use base 'Test::Class';

use Test::More;

use Bar;

sub role : Test(2) {
    my $self = shift;

    my $bar = Bar->new;
    is $bar->public => 1;
    ok !$bar->can('_protected');

}

1;
