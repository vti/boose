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

sub role_without_requires : Test(1) {
    my $self = shift;

    {

        package RoleWithoutRequires;
        use Boose::Role;

        sub new_method {1}
    }

    {

        package WithRole;
        use Boose;

        with 'RoleWithoutRequires';
    }

    my $foo = WithRole->new;
    is $foo->new_method => 1;
}

1;
