package Boose::Exception;

use Boose::Loader;
use Boose::Util;

use Try::Tiny;
use Scalar::Util 'blessed';
require Carp;

sub caught {
    my $self = shift;
    my ($e, $class) = @_;

    return if !blessed $e;

    return !!$e->isa($class);
}

sub throw {
    my $self  = shift;
    my $class = shift;

    my $e;

    if ($class->isa('Boose::Exception::Base')) {
        if (blessed($class)) {
            $e = $class;
        }
        else {
            $e = $class->new(@_);
        }
    }
    else {
        $e = $class;
    }

    Carp::croak($e);
}

1;
