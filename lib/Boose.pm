package Boose;

use 5.010;
use strict;
use warnings;

use feature ();

our $VERSION = '0.0001';

sub import {
    my $package = caller;

    # From Modern::Perl
    strict->import;
    warnings->import;
    feature->import(':5.10');

    fix_isa($package);

    install_sub($package => has => \&has);
}

sub fix_isa {
    my $package = shift;

    require Boose::Base;

    no strict 'refs';
    unshift @{"$package\::ISA"}, 'Boose::Base';
}

sub has {
    my $names = shift;
    my $args  = shift;

    $args ||= {};

    my $package = caller();

    $names = [$names] unless ref $names eq 'ARRAY';

    foreach my $name (@$names) {
        install_attr($package, $name, $args);
    }
}

sub install_attr {
    my $package = shift;
    my $attr    = shift;

    install_sub(
        $package => $attr => sub {
            @_ > 1
              ? do { $_[0]->{$attr} = $_[1]; $_[0] }
              : $_[0]->{$attr};
        }
    );
}

sub install_sub {
    my $package = shift;
    my $name    = shift;
    my $sub     = shift;

    return if $package->can($name);

    no strict 'refs';
    *{$package . '::' . $name} = $sub;
}

1;
