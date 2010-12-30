package Boose::Base;

use strict;
use warnings;

require Carp;

use Boose::Meta;
use Boose::Loader;
use Boose::Util qw(install_sub install_alias);

use Scalar::Util 'weaken';

our @RESERVED_NAMES = (qw/new has static throw meta attr get set/);

sub new {
    my $class = shift;
    $class = ref $class if ref $class;

    my $self = {@_};
    bless $self, $class;

    foreach my $key (keys %$self) {
        Carp::croak(
            "Unknown attribute '$key' passed to the 'new' contructor of '$class'"
        ) unless $self->meta->attr_exists($key);
    }

    $self->BUILD if $self->can('BUILD');

    return $self;
}

sub DESTROY { }

sub meta {
    my $class = shift;
    $class = ref $class if ref $class;

    return $Boose::Meta::classes{$class} ||= Boose::Meta->new($class);
}

sub attr {
    my $package = shift;
    my $names   = shift;

    Carp::croak('->attr must be called on class, not object')
      if ref $package;

    $names = [$names] unless ref $names eq 'ARRAY';

    my @args = @_;
    foreach my $name (@$names) {
        Carp::croak(qq/'$name' is a reserved name/) if grep {$name eq $_} @RESERVED_NAMES;
        _install_attr($package, $name, @args);
    }
}

sub add_role {
    my $package = shift;
    my $class   = shift;

    Boose::Loader::load($class);

    $class->check_required_methods($package);
    $class->import_methods;
}

sub get {
    my $self = shift;
    my $name = shift;

    Carp::croak("Attribute's name is required") unless defined $name;

    my $attr = $self->meta->attr($name);

    if ($attr->is_static) {
        return $attr->static_value;
    }
    else {
        return $self->{$name} if exists $self->{$name};
    }

    my $default = $attr->default;
    $default = $default->($self) if ref $default eq 'CODE';

    return $self->{$name} = $default;
}

sub set {
    my $self  = shift;
    my $name  = shift;
    my $value = shift;

    Carp::croak("Attribute's name is required") unless defined $name;

    my $attr = $self->meta->attr($name);

    if ($attr->is_static) {
        $attr->set_static_value($value);
    }
    else {
        $self->{$name} = $value;
    }

    if ($attr->is_weak_ref) {
        if ($attr->is_static) {
            die 'TODO';
        }
        weaken $self->{$name};
    }

    return $self;
}

sub _install_attr {
    my $package = shift;
    my $name    = shift;

    my $attr = $package->meta->add_attr($name, @_);
    return if not defined $attr->is;

    install_sub(
        $package => "get_$name" => sub {
            Carp::croak("To change '$name' value, use 'set_$name' instead")
              if @_ > 1;
            $_[0]->get($name);
        }
    );

    install_alias($package => $name => "get_$name");

    if ($attr->is ne 'ro') {
        install_sub(
            $package => "set_$name" => sub {
                shift->set($name => @_);
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
