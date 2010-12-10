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
    my @args  = @_;

    my $path = class_to_path($class);

    # Can't use Boose::Loader here, because
    # the exception could be thrown from it too
    my $new;
    try {
        if (!is_class_loaded($class)) {
            require $path;
        }

        $new = $class->new(@args);
    }
    catch {
        Carp::croak("Can't throw exception '$class': $_");
    };

    Carp::croak($new) if $new;
}

1;
