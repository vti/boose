#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 21;

use_ok('Boose::Iterator');
use_ok('Boose::IteratorPaged');

my $i;
my $page;
my $element;

$i = Boose::IteratorPaged->new(Boose::Iterator->new);
is $i->size => 0;
ok not defined $i->next(10)->next;
ok not defined $i->next(10)->prev;
ok not defined $i->prev(10)->prev;
ok not defined $i->prev(10)->next;

$i =
  Boose::IteratorPaged->new(
    Boose::Iterator->new({name => 1}, {name => 2}, {name => 3}));
is $i->size => 3;

$i->rewind;

$page = $i->next(10);
ok $page->isa('Boose::IteratorPaged');
is $page->size => 3;
ok not defined $i->next;

$page = $i->next(10);
ok $page->isa('Boose::IteratorPaged');
is $page->size => 0;

$i->rewind;
$page = $i->prev(10);
is $page->size => 0;

$i->rewind;
is $i->next(10)->size => 3;
$page = $i->prev(10);
is $page->size => 2;
ok not defined $i->prev;

$i->rewind;
$page = $i->next(2);
is $page->size => 2;

$i->next;
$i->next;
ok not defined $i->next;
$page = $i->prev(3);
is $page->size => 2;
ok not defined $i->prev;
