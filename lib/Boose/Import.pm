package Boose::Import;

use strict;
use warnings;

use Boose::Loader;
use Boose::Util 'install_sub';

use mro     ();
use feature ();

sub import {
    my $class      = shift;
    my $base_class = shift;

    my $package = caller;

    # From Modern::Perl
    strict->import;
    warnings->import;
    feature->import(':5.10');
    mro::set_mro($package => 'c3');

    install_sub($package => extends => \&extends);

    if ($base_class) {
        if ($base_class =~ m/^::/) {
            $base_class = "Boose$base_class";
        }

        extend($package => $base_class);
    }

    $class->import_finalize($package);
}

sub extends {
    my $class = shift;

    my $package = caller;

    extend($package => $class);
}

sub extend {
    my $package = shift;
    my $class   = shift;

    Boose::Loader::load($class);

    no strict 'refs';

    if ($class->isa('Boose::Base') && @{"$package\::ISA"}) {
        pop @{"$package\::ISA"};
    }

    unshift @{"$package\::ISA"}, $class;
}

1;
