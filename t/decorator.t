#!/usr/bin/env perl

{

    package Foo;
    use Boose;

    extends 'Boose::Base';

    sub foo {'Hello'}
}

{

    package Bar;
    use Boose;

    extends 'Boose::Decorator';

    sub foo { shift->decorated->foo . ' there' }
}

package main;

use Test::More tests => 1;

use Data::Dumper;

my $bar = Bar->new(Foo->new);
is $bar->foo => 'Hello there';
