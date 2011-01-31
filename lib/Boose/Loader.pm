package Boose::Loader;

use strict;
use warnings;

require Class::Load;
use Try::Tiny;

use Boose::Exception::ClassNotFound;
use Boose::Exception::CantLoadClass;

sub load {
    my $class = shift;

    try {
        Class::Load::load_class($class);
    }
    catch {
        my $e = $_;

        if ($e =~ m/\ACan't locate .* in \@INC/) {
            Boose::Exception::ClassNotFound->throw(class => $class);
        }
        else {
            Boose::Exception::CantLoadClass->throw(
                class       => $class,
                description => "$e"
            );
        }
    };

    return 1;
}

1;
