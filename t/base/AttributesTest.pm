package AttributesTest;

use strict;
use warnings;

use base 'Test::Class';

use Test::More;
use Try::Tiny;

use Class;
use ClassWithDefaults;
use ClassWithException;
use ClassWithStatic;

sub _build_object                { shift; Class->new(@_) }
sub _build_object_with_defaults  { shift; ClassWithDefaults->new(@_) }
sub _build_object_with_exception { shift; ClassWithException->new(@_) }
sub _build_object_with_static    { shift; ClassWithStatic->new(@_) }

sub isa_is_correct : Test(1) {
    my $self = shift;

    my $object = $self->_build_object;

    ok $object->isa('Boose::Base');
}

sub empty : Test(3) {
    my $self = shift;

    my $object = $self->_build_object;

    ok not defined $object->get_foo;
    ok not defined $object->get_bar;
    ok not defined $object->get_baz;
}

sub getters : Test(2) {
    my $self = shift;

    my $object = $self->_build_object(foo => 'bar');

    is $object->get_foo => 'bar';
    is $object->foo     => 'bar';
}

sub attempt_setting_value_via_getter : Test(2) {
    my $self = shift;

    my $object = $self->_build_object;

    my $e;
    try {
        $object->foo('bar');
    }
    catch {
        $e = $_;
    };

    ok $e;
    like $e => qr/To change 'foo' value, use 'set_foo' instead/;
}

sub constructor_with_unknown_attribute : Tests(1) {
    my $self = shift;

    local $@;
    eval { Class->new(hello => 'foo'); };
    like $@ => qr/Unknown attribute/;
}

sub unknown_attribute : Test(1) {
    my $self = shift;

    my $object = $self->_build_object;

    my $e;
    try {
        $object->set(unknown_attr => 'bar');
    }
    catch {
        $e = $_;
    };

    like $e => qr/Unknown attribute 'unknown_attr'/;
}

sub attempt_to_set_ro_attribute : Test(2) {
    my $self = shift;

    my $e;
    try { $self->_build_object(read_only => 2) } catch { $e = $_; };
    like $e => qr/Attribute 'read_only' is read only/;

    my $object = $self->_build_object;

    try { $object->set_read_only(1); } catch { $e = $_ };
    like $e => qr/Attribute 'read_only' is read only/;
}

sub overwritable_mutator : Test(2) {
    my $self = shift;

    my $object = $self->_build_object(overwritable => '123');
    is $object->overwritable => 'one23';

    $object->set_overwritable('123');
    is $object->overwritable => 'one23';
}

sub empty_with_defaults : Test(5) {
    my $self = shift;

    my $object = $self->_build_object_with_defaults;
    is $object->get_num          => 1;
    is $object->get_str          => 'Hello';
    is_deeply $object->get_array => [qw/1 2 3/];
    is_deeply $object->get_hash  => {foo => 'bar'};
    is $object->get_code         => 1;
}

sub empty_values : Test(4) {
    my $self = shift;

    my $object = $self->_build_object_with_defaults(
        num   => 0,
        str   => '',
        array => [],
        hash  => {}
    );
    is $object->get_num          => 0;
    is $object->get_str          => '';
    is_deeply $object->get_array => [];
    is_deeply $object->get_hash  => {};
}

sub undef_values : Test(4) {
    my $self = shift;

    my $object = $self->_build_object_with_defaults(
        num   => undef,
        str   => undef,
        array => undef,
        hash  => undef
    );
    ok not defined $object->get_num;
    ok not defined $object->get_str;
    ok not defined $object->get_array;
    ok not defined $object->get_hash;
}

sub arg_as_a_single_value_is_default_value : Test(1) {
    my $self = shift;

    my $object = $self->_build_object_with_defaults;
    is $object->get_simple => 2;
}

sub chain : Test(3) {
    my $self = shift;

    my $object = $self->_build_object(baz => 1);

    $object->set_foo(1)->set_bar(0)->set_baz(undef);
    is $object->get_foo => 1;
    is $object->get_bar => 0;
    ok not defined $object->get_baz;
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

sub weak_refs : Test(1) {
    my $self = shift;

    my $object = $self->_build_object;

    my $hash_ref = {foo => 'bar'};

    $object->set_weak($hash_ref);
    undef $hash_ref;

    ok not defined $object->weak;
}

sub static_attribute : Test(4) {
    my $self = shift;

    ClassWithStatic->set_state('foo');
    is(ClassWithStatic->state, 'foo');

    my $object = $self->_build_object_with_static;
    is $object->state => 'foo';

    $object->set_state('bar');
    is $object->state => 'bar';
    is(ClassWithStatic->state, 'bar');
}

sub static_attribute_with_default : Test(1) {
    my $self = shift;

    is_deeply(ClassWithStatic->default, {});
}

1;
