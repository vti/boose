#!/usr/bin/env perl

{

    package Foo;
    use Boose;

    sub foo {'Hello'}
}

{

    package Bar;
    use Boose '::Decorator';

    sub foo { shift->get_decorated->foo . ' there' }
}

package main;

use Test::More tests => 1;

my $bar = Bar->new(Foo->new);
is $bar->foo => 'Hello there';
