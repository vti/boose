package Boose::Loader;

use strict;
use warnings;

use Boose::Exception;
use Boose::Util;
use Try::Tiny;

sub is_valid_class_name {
    my $class = shift;

    return 1 if $class =~ m/^[A-Za-z][A-Za-z0-9:_]+$/x;

    return;
}

sub load {
    my $class = shift;

    Carp::croak('Class name is invalid') unless is_valid_class_name($class);

    return if is_class_loaded($class);

    my $path = class_to_path($class);

    try {
        require $path;
    }
    catch {
        my $e = $_;

        if ($e =~ m/\ACan't locate $path in \@INC/) {
            Boose::Exception->throw('Boose::Exception::ClassNotFound',
                class => $class);
        }
        else {
            Boose::Exception->throw(
                'Boose::Exception::CantLoadClass',
                class       => $class,
                description => "$e"
            );
        }
    };

    return 1;
}

1;
