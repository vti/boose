package Boose::Import;

use strict;
use warnings;

use Boose::Loader;
use Boose::Util 'install_sub';

use mro     ();
use feature ();

sub import {
    my $class   = shift;
    my $package = caller;

    # From Modern::Perl
    strict->import;
    warnings->import;
    feature->import(':5.10');
    mro::set_mro($package => 'c3');

    install_sub($package => extends => \&extends);

    $class->import_finalize($package);
}

sub extends {
    my $class = shift;

    my $package = caller;

    Boose::Loader::load($class);

    no strict 'refs';

    if ($class->isa('Boose::Base') && @{"$package\::ISA"}) {
        pop @{"$package\::ISA"};
    }

    unshift @{"$package\::ISA"}, $class;
}

1;
