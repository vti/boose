package Boose;

use 5.010;
use strict;
use warnings;

use feature ();

require Carp;

our $VERSION = '0.0001';

sub import {
    strict->import;
    warnings->import;
    feature->import(':5.10');

    my $package = caller;

    install_new($package);

    install_sub($package => has => \&has);
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

sub install_new {
    my $package = shift;

    install_sub(
        $package => new => sub {
            my $class = shift;
            $class = ref $class if ref $class;

            my $self = {@_};

            bless $self, $class;

            foreach my $key (keys %$self) {
                Carp::croak("Unknown attribute $key") unless $self->can($key);
            }

            return $self;
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
