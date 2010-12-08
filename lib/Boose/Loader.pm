package Boose::Loader;

use strict;
use warnings;

use Boose::Loader::Exception;
use Try::Tiny;

sub is_class_loaded {
    my $class = shift;

    return 1 if $class->can('new');

    return;
}

sub is_valid_class_name {
    my $class = shift;

    return 1 if $class =~ m/^[A-Za-z][A-Za-z0-9:_]+$/x;

    return;
}

sub load {
    my $class = shift;

    Carp::croak('Class name is invalid') unless is_valid_class_name($class);

    return if is_class_loaded($class);

    $class =~ s{::}{/};
    $class .= '.pm';

    my $e;

    try {
        require $class;
    }
    catch {
        $e = Boose::Loader::Exception->new($_, class => $class);
    };

    #do {
        #local $@;
        #eval {require $class;};
        #$e = Boose::Loader::Exception->new($@, class => $class) if $@;
        #return $e;
    #};

    return $e;
}

1;
