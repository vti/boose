#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 16;

use_ok('Boose::Iterator');

my $i;
my $page;
my $element;

$i = Boose::Iterator->new;
is $i->size => 0;
ok not defined $i->next;
ok not defined $i->prev;
ok not defined $i->first;
ok not defined $i->last;

$i = Boose::Iterator->new({name => 3}, {name => 2}, {name => 1});
is $i->size => 3;

$i->reverse;

$element = $i->next;
ok $element;
is $element->{name} => 1;

$element = $i->next;
ok $element;
is $element->{name} => 2;

$i->next;

ok not defined $i->next;

$i->rewind;

ok $i->current;
is $i->current->{name} => 1;
$i->next;
is $i->current->{name} => 1;

$i = Boose::Iterator->new([1, 2, 3]);
my $sum = 0;
$i->each(sub { $sum += $_[1] });
is $sum => 6;
