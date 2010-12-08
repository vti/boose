#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 12;

use lib 't/lib';

use_ok('Boose::Loader');

my $e;

$e = Boose::Loader::load('UnlikelyToExist42');
ok $e->error;
ok $e->not_found;
ok !$e->has_errors;

$e = Boose::Loader::load('ClassWithSyntaxErrors');
ok $e->error;
ok !$e->not_found;
ok $e->has_errors;

ok Boose::Loader::is_valid_class_name('FooBar');
ok Boose::Loader::is_valid_class_name('FooBar_');
ok Boose::Loader::is_valid_class_name('FooBar::_Baz');
ok Boose::Loader::is_valid_class_name('FooBar::_Baz123');

ok !Boose::Loader::is_valid_class_name('123');
