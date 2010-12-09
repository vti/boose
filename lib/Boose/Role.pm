package Boose::Role;

use strict;
use warnings;

use base 'Boose::Import';

use Boose::Util 'install_sub';

sub import_finalize {
    my ($class, $package) = @_;

    install_sub($package => requires => \&requires);
}

sub requires { caller->require_methods(@_) }

1;
