#!/usr/bin/env perl

use strict;
use warnings;

use lib 't/lib';

package Bar;
use Boose;

extends 'Boose::Base';

with 'FooRole';

sub required {}

package main;

use Test::More tests => 2;

my $bar = Bar->new;
is $bar->public => 1;
ok !$bar->can('_protected');
