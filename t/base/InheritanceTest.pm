package InheritanceTest;

use strict;
use warnings;

use base 'Test::Class';

use Test::More;

use Child;
use ChildOfNormalClass;

sub _build_object { shift; Child->new(@_) }

sub isa_is_correct : Test(3) {
    my $self = shift;

    my $object = $self->_build_object(foo => 1, foofoo => 2);

    ok $object->isa('Child');
    is $object->get_foo    => 1;
    is $object->get_foofoo => 2;
}

sub normal_class : Test(2) {
    my $self = shift;

    my $object = ChildOfNormalClass->new('there');
    $object->set_foo('hello');

    is $object->foo => 'hello';
    is $object->hello => 'there';
}

1;
