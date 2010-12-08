#!/usr/bin/env perl

{

    package Foo;
    use Boose;

    use base 'Boose::Base';

    sub foo {'Hello'}
}

{

    package Bar;
    use Boose;

    use base 'Boose::Decorator';

    sub foo { shift->decorated->foo . ' there' }
}

package main;

use Test::More tests => 1;

use Data::Dumper;

my $bar = Bar->new(Foo->new);
is $bar->foo => 'Hello there';
