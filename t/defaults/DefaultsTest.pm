package IteratorTest;

use strict;
use warnings;

use base 'Test::Class';

use Test::More;

use Foo;

sub _create_object { shift; Foo->new(@_) }

sub empty_constructor : Test(4) {
    my $self = shift;

    my $foo = $self->_create_object;
    is $foo->num          => 1;
    is $foo->str          => 'Hello';
    is_deeply $foo->array => [qw/1 2 3/];
    is_deeply $foo->hash  => {foo => 'bar'};
}

sub empty_values : Test(4) {
    my $self = shift;

    my $foo =
      $self->_create_object(num => 0, str => '', array => [], hash => {});
    is $foo->num          => 0;
    is $foo->str          => '';
    is_deeply $foo->array => [];
    is_deeply $foo->hash  => {};
}

sub undef_values : Test(4) {
    my $self = shift;

    my $foo = $self->_create_object(
        num   => undef,
        str   => undef,
        array => undef,
        hash  => undef
    );
    ok not defined $foo->num;
    ok not defined $foo->str;
    ok not defined $foo->array;
    ok not defined $foo->hash;
}

sub arg_as_a_single_value_is_default_value : Test(1) {
    my $self = shift;

    my $foo = $self->_create_object;
    is $foo->simple => 2;
}

1;
