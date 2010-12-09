package Boose;

use 5.010;
use strict;
use warnings;

use mro     ();
use feature ();

use Boose::Loader;
use Boose::Base;

use Try::Tiny;

our $VERSION = '0.0001';

sub import {
    my $package = caller;

    # From Modern::Perl
    strict->import;
    warnings->import;
    feature->import(':5.10');
    mro::set_mro($package => 'c3');

    _install_sub($package => extends => \&extends);
    _install_sub($package => has     => \&has);

    _install_sub($package => throw   => \&throw);
    _install_sub($package => try     => \&try);
    _install_sub($package => catch   => \&catch);
    _install_sub($package => finally => \&finally);
}

sub extends {
    my $class = shift;

    my $package = caller;

    Boose::Loader::load($class);

    no strict 'refs';
    push @{"$package\::ISA"}, $class;
}

sub has { Boose::Base->attr(@_) }

sub throw {
    my $class = shift;
}

sub _install_sub {
    my $package = shift;
    my $name    = shift;
    my $sub     = shift;

    return if $package->can($name);

    no strict 'refs';
    *{$package . '::' . $name} = $sub;
}

1;
