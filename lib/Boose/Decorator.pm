package Boose::Decorator;

use Boose;

has 'decorated';

sub new {
    my $class = shift;
    my @args = @_ % 2 != 0 ? (decorated => shift, @_) : @_;

    return $class->SUPER::new(@args);
}

our $AUTOLOAD;

sub AUTOLOAD {
    my $self = shift;

    my $method = $AUTOLOAD;

    return if $method =~ /^[A-Z]+?$/;
    return if $method =~ /^_/;
    return if $method =~ /(?:\:*?)DESTROY$/;

    $method = (split '::' => $method)[-1];

    return $self->get_decorated->$method(@_);
}

1;
