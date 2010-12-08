package Boose;

use 5.010;
use strict;
use warnings;

use mro     ();
use feature ();
use Try::Tiny;

our $VERSION = '0.0001';

sub import {
    my $package = caller;

    # From Modern::Perl
    strict->import;
    warnings->import;
    feature->import(':5.10');
    mro::set_mro($package => 'c3');

    install_sub($package => extends => \&extends);
    install_sub($package => has     => \&has);

    install_sub($package => try     => \&try);
    install_sub($package => catch   => \&catch);
    install_sub($package => finally => \&finally);
}

sub has {
    my $names = shift;
    my $args  = shift;

    $args ||= {};

    my $package = caller;

    $names = [$names] unless ref $names eq 'ARRAY';

    foreach my $name (@$names) {
        install_attr($package, $name, $args);
    }
}

sub install_attr {
    my $package = shift;
    my $attr    = shift;
    my $args    = shift;

    install_sub(
        $package => $attr => sub {
            @_ > 1
              ? do { $_[0]->{$attr} = $_[1]; $_[0] }
              : do {
                return $_[0]->{$attr} if exists $_[0]->{$attr};

                my $default = ref $args eq 'HASH' ? $args->{default} : $args;
                return unless defined $default;

                Carp::croak('Default value must be a SCALAR or CODEREF')
                  if ref $default && ref $default ne 'CODE';

                $_[0]->{$attr} =
                  ref $default eq 'CODE'
                  ? $default->($_[0])
                  : $default;
              };
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
