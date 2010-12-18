package Boose::Exception;

use Boose::Loader;
use Boose::Util;

use Try::Tiny;
use Scalar::Util 'blessed';
require Carp;

our @CARP_NOT = 'Boose';

sub caught {
    my $self = shift;
    my ($e, $class) = @_;

    return if !blessed $e;

    return !!$e->isa($class);
}

sub throw {
    my $self = shift;
    my $e    = shift;

    eval {
        if ($e->isa('Boose::Exception::Base')) {
            if (!blessed($e)) {
                $e = $e->new(@_);
            }
        }
    };

    Carp::croak($e);
}

1;
