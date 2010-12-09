package Boose::Base;

use strict;
use warnings;

require Carp;

sub new {
    my $class = shift;
    $class = ref $class if ref $class;

    my $self = {@_};

    bless $self, $class;

    foreach my $key (keys %$self) {
        Carp::croak(
            "Unknown attribute '$key' passed to the 'new' contructor of '$class'"
        ) unless $self->can($key);
    }

    $self->BUILD if $self->can('BUILD');

    return $self;
}

sub DESTROY { }

sub attr {
    my $package = shift;
    my $names   = shift;
    my $args    = shift;

    Carp::croak('->attrs must be called on class, not on object')
      if ref $package;

    $names = [$names] unless ref $names eq 'ARRAY';

    foreach my $name (@$names) {
        Carp::croak(
            "Your attr name '$name' conflicts with class '$package' method")
          if $package->can($name);

        _install_attr($package, $name, $args);
    }
}

sub _install_attr {
    my ($package, $name, $args) = @_;

    $args ||= {};

    no strict 'refs';
    *{$package . '::' . $name} = sub {
        @_ > 1
          ? do { $_[0]->{$name} = $_[1]; $_[0] }
          : do {
            return $_[0]->{$name} if exists $_[0]->{$name};

            my $default = ref $args eq 'HASH' ? $args->{default} : $args;
            return unless defined $default;

            Carp::croak('Default value must be a SCALAR or CODEREF')
              if ref $default && ref $default ne 'CODE';

            $_[0]->{$name} =
              ref $default eq 'CODE'
              ? $default->($_[0])
              : $default;
          };
    };
}

sub throw {
    my $class   = shift;
    my $message = shift;

    Carp::croak($message);
}

1;
