package Boose::Base;

use strict;
use warnings;

require Carp;

use Boose::Loader;
use Boose::Util 'install_sub';

sub new {
    my $class = shift;
    $class = ref $class if ref $class;

    my $self = {@_};

    bless $self, $class;

    foreach my $key (keys %$self) {
        Carp::croak(
            "Unknown attribute '$key' passed to the 'new' contructor of '$class'"
        ) unless $self->can("get_$key");
    }

    $self->BUILD if $self->can('BUILD');

    return $self;
}

sub DESTROY { }

sub attr {
    my $package = shift;
    my $names   = shift;
    my $args    = shift;

    Carp::croak('->attr must be called on class, not object')
      if ref $package;

    $names = [$names] unless ref $names eq 'ARRAY';

    foreach my $name (@$names) {
        _install_attr($package, $name, $args);
    }
}

sub add_role {
    my $package = shift;
    my $class   = shift;

    Boose::Loader::load($class);

    $class->check_required_methods($package);
    $class->import_methods;
}

sub throw {
    my $class   = shift;
    my $message = shift;

    Carp::croak($message);
}

sub get {
    my $self = shift;
    my $name = shift;

    Carp::croak('Attribute name is required') unless defined $name;

    my $method = "get_$name";
    return $self->$method;
}

sub set {
    my $self = shift;
    my $name = shift;

    Carp::croak('Attribute name is required') unless defined $name;

    my $method = "set_$name";
    return $self->$method(@_);
}

sub _install_attr {
    my ($package, $name, $args) = @_;

    Carp::croak(
        "Your attr name '$name' conflicts with class '$package' method")
      if $package->can($name);

    $args ||= {};
    $args = {default => $args} if ref $args ne 'HASH';

    my $default = $args->{default};

    Carp::croak('Default value must be a SCALAR or CODEREF')
      if ref $default && ref $default ne 'CODE';

    my $is = delete $args->{is} || '';

    install_sub(
        $package => "get_$name" => sub {
            return $_[0]->{$name} if exists $_[0]->{$name};

            $_[0]->{$name} =
              ref $default eq 'CODE'
              ? $default->($_[0])
              : $default;
        }
    );

    if ($is ne 'ro') {
        install_sub(
            $package => "set_$name" => sub {
                $_[0]->{$name} = $_[1];
                $_[0];
            }
        );
    }
    else {
        install_sub(
            $package => "set_$name" => sub {
                Carp::croak("Attribute '$name' is read only");
            }
        );
    }
}

1;
