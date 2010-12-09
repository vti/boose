package Boose::Exception;

use Boose::Loader;
use Boose::Util 'class_to_path';

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
    my @args = @_;

    my $path = class_to_path($class);

    # Can't use Boose::Loader here, because
    # the exception could be thrown from it too
    my $new;
    try {
        require $path;
        $new = $class->new(@args);
    }
    catch {
        Carp::croak("Can't throw exception '$class': $_");
    };

    $new->throw if $new;
}

1;