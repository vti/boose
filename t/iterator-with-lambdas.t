#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 7;

use_ok('Boose::Iterator');
use_ok('Boose::IteratorWithLambdas');

my $i;

$i = Boose::IteratorWithLambdas->new(Boose::Iterator->new);
is $i->size => 0;
ok not defined $i->first(sub { $_[1] eq 'foo' ? $_[1] : undef });

$i = Boose::IteratorWithLambdas->new(Boose::Iterator->new(qw/foo bar baz/));
is $i->size => 3;
is $i->first(sub { $_[1] eq 'bar' ? $_[1] : undef }) => 'bar';

$i = Boose::IteratorWithLambdas->new(Boose::Iterator->new(1, 2, 3));
my $sum = 0;
$i->each(sub { $sum += $_[1] });
is $sum => 6;
