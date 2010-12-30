package Boose::Role;

use strict;
use warnings;

use base 'Boose::Import';

use Boose::Role::Base;
use Boose::Util 'install_sub';

sub import_finalize {
    my ($class, $package) = @_;

    {
        no strict 'refs';
        push @{"$package\::ISA"}, "$class\::Base";
    }

    install_sub($package => requires => \&requires);
}

sub requires { caller->require_methods(@_) }

1;
