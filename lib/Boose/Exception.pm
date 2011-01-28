package Boose::Exception;

use strict;
use warnings;

use base 'Boose::Base';

use Scalar::Util 'blessed';
require Carp;

our @CARP_NOT = qw(Boose Boose::Base);

use overload '""' => sub { shift->to_string }, fallback => 1;
use overload 'bool' => sub { shift; }, fallback => 1;

__PACKAGE__->attr(message => 'Unknown exception');

sub to_string { shift->message }

sub throw {
    my $self = shift;

    my $e;

    if (@_ == 1) {
        $e = $_[0];
    }
    elsif (blessed($self)) {
        $e = $self;
    }
    else {
        $e = $self->new(@_);
    }

    Carp::croak($e);
}

sub caught {
    my $self = shift;
    my ($e, $class) = @_;

    ($class, $e) = ($e, $_) unless $class;

    return if !blessed $e;

    return !!$e->isa($class);
}

1;
