#!/usr/bin/env perl

package Foo;
use Boose;

has [qw/foo bar/];
has 'baz';
has 'wrong';

sub wrong {1}

package main;

use Test::More tests => 15;

my $foo = Foo->new;
ok not defined $foo->foo;
ok not defined $foo->bar;
ok not defined $foo->baz;

$foo = Foo->new(foo => 'bar');
is $foo->foo => 'bar';
ok not defined $foo->bar;
ok not defined $foo->baz;

$foo = Foo->new(bar => undef);
ok not defined $foo->bar;

$foo = Foo->new(foo => 0, bar => 1, baz => 3);
is $foo->foo => 0;
is $foo->bar => 1;
is $foo->baz => 3;

$foo = Foo->new(baz => 1);
$foo->foo(1)->bar(0)->baz(undef);
is $foo->foo => 1;
is $foo->bar => 0;
ok not defined $foo->baz;

{
    local $@;
    eval { $foo = Foo->new(hello => 'foo'); };
    ok $@;
}

$foo = Foo->new;
is $foo->wrong => 1;
