package MethodModifiersTest;

use strict;
use warnings;

use base 'Test::Class';

use Test::More;
use Try::Tiny;

use ClassWithMethodModifiers;

sub simple : Test(1) {
    my $self = shift;

    my $object = ClassWithMethodModifiers->new;

    $object->method;

    is $object->{message} => 'before_method_after';
}

1;
