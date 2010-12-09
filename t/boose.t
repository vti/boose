#!/usr/bin/env perl

package Foo;
use Boose;

extends 'Boose::Base';

has [qw/foo bar/];
has 'baz';
has 'default';

sub new {
    my $self = shift->SUPER::new(@_);

    $self->{default} //= 1;

    return $self;
}

sub wrong {1}

package Bar;
use Boose;

extends 'Foo';

has 'foofoo';

sub new {
    my $self = shift->SUPER::new(@_);

    $self->{foofoo} //= 3;

    return $self;
}

sub mortal {
    throw 'Bar::Exception', message => 'Error!';
}

package Bar::Exception;
use base 'Boose::Exception::Base';

package main;

use Test::More tests => 22;

use Try::Tiny;

my $foo = Foo->new;
ok $foo->isa('Boose::Base');
is $foo->default => 1;

$foo = Foo->new;
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

my $bar = Bar->new(foo => 1, foofoo => 2);
ok $bar->isa('Foo');
is $bar->foo    => 1;
is $bar->foofoo => 2;

$bar = Bar->new;
is $bar->foofoo => 3;

try {
    $bar->mortal;
}
catch {
    is $_ => 'Error!';
};
