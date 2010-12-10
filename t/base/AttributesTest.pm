package AttributesTest;

use strict;
use warnings;

use base 'Test::Class';

use Test::More;
use Try::Tiny;

use Class;
use ClassWithDefaults;
use ClassWithException;

sub _build_object                { shift; Class->new(@_) }
sub _build_object_with_defaults  { shift; ClassWithDefaults->new(@_) }
sub _build_object_with_exception { shift; ClassWithException->new(@_) }

sub isa_is_correct : Test(1) {
    my $self = shift;

    my $object = $self->_build_object;

    ok $object->isa('Boose::Base');
}

sub empty : Test(3) {
    my $self = shift;

    my $object = $self->_build_object;

    ok not defined $object->foo;
    ok not defined $object->bar;
    ok not defined $object->baz;
}

sub constructor_with_unknown_attribute : Tests(1) {
    my $self = shift;

    local $@;
    eval { Class->new(hello => 'foo'); };
    like $@ => qr/Unknown attribute/;
}

sub empty_with_defaults : Test(4) {
    my $self = shift;

    my $object = $self->_build_object_with_defaults;
    is $object->num          => 1;
    is $object->str          => 'Hello';
    is_deeply $object->array => [qw/1 2 3/];
    is_deeply $object->hash  => {foo => 'bar'};
}

sub empty_values : Test(4) {
    my $self = shift;

    my $object = $self->_build_object_with_defaults(
        num   => 0,
        str   => '',
        array => [],
        hash  => {}
    );
    is $object->num          => 0;
    is $object->str          => '';
    is_deeply $object->array => [];
    is_deeply $object->hash  => {};
}

sub undef_values : Test(4) {
    my $self = shift;

    my $object = $self->_build_object_with_defaults(
        num   => undef,
        str   => undef,
        array => undef,
        hash  => undef
    );
    ok not defined $object->num;
    ok not defined $object->str;
    ok not defined $object->array;
    ok not defined $object->hash;
}

sub arg_as_a_single_value_is_default_value : Test(1) {
    my $self = shift;

    my $object = $self->_build_object_with_defaults;
    is $object->simple => 2;
}

sub chain : Test(3) {
    my $self = shift;

    my $object = $self->_build_object(baz => 1);

    $object->foo(1)->bar(0)->baz(undef);
    is $object->foo => 1;
    is $object->bar => 0;
    ok not defined $object->baz;
}

sub exception : Test(1) {
    my $self = shift;

    my $object = $self->_build_object_with_exception;

    try {
        $object->mortal;
    }
    catch {
        is $_ => 'Error!';
    };
}

1;
