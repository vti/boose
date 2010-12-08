package Boose::Decorator;
use Boose;

use base 'Boose::Base';

has 'decorated';

require Carp;

sub new {
    my $class     = shift;
    my $decorated = shift;

    Carp::croak('Decorated object is required') unless defined $decorated;

    my $self = $class->SUPER::new(@_);

    $self->decorated($decorated);

    return $self;
}

our $AUTOLOAD;

sub AUTOLOAD {
    my $self = shift;

    my $method = $AUTOLOAD;

    return if $method =~ /^[A-Z]+?$/;
    return if $method =~ /^_/;
    return if $method =~ /(?:\:*?)DESTROY$/;

    $method = (split '::' => $method)[-1];

    return $self->decorated->$method(@_);
}

1;
