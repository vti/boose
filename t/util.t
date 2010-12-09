#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 1;

use Boose::Util;

is class_to_path('Foo::Bar::Baz') => 'Foo/Bar/Baz.pm';
