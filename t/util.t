#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 10;

use Boose::Util;

is class_to_path('Foo::Bar::Baz') => 'Foo/Bar/Baz.pm';

is clone(1)     => 1;
is clone("foo") => "foo";

my $orig = "foo";
my $dest = clone(\$orig);
$orig = "bar";
is $$dest => "foo";

is_deeply clone({foo => 'bar'}) => {foo => 'bar'};
is_deeply clone({foo => 'bar', baz => {hello => 'there'}}) =>
  {foo => 'bar', baz => {hello => 'there'}};

is_deeply clone([1, 2, 3]) => [1, 2, 3];
is_deeply clone([1, 2, [3, 4]]) => [1, 2, [3, 4]];

is clone(\&closure) => \&closure;

is_deeply clone([1, 2, {foo => ['bar'], sub => \&closure}]) =>
  [1, 2, {foo => ['bar'], sub => \&closure}];

sub closure {'hello'}
