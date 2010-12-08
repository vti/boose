#!/usr/bin/env perl

package Foo;
use Boose;

extends 'Boose::Base';

has 'num' => {default => 1};
has 'str' => {default => 'Hello'};
has 'array' => {
    default => sub { [qw/1 2 3/] }
};
has 'hash' => {
    default => sub { {foo => 'bar'} }
};

has 'simple' => 2;

package main;

use Test::More tests => 13;

my $foo = Foo->new;
is $foo->num          => 1;
is $foo->str          => 'Hello';
is_deeply $foo->array => [qw/1 2 3/];
is_deeply $foo->hash  => {foo => 'bar'};

$foo = Foo->new(num => 0, str => '', array => [], hash => {});
is $foo->num          => 0;
is $foo->str          => '';
is_deeply $foo->array => [];
is_deeply $foo->hash  => {};

$foo = Foo->new(num => undef, str => undef, array => undef, hash => undef);
ok not defined $foo->num;
ok not defined $foo->str;
ok not defined $foo->array;
ok not defined $foo->hash;

$foo = Foo->new;
is $foo->simple => 2;
