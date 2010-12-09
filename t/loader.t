#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 6;

use lib 't/lib';

use_ok('Boose::Loader');

use Try::Tiny;

try {
    Boose::Loader::load('UnlikelyToExist42');
}
catch {
    ok Boose::Exception->caught($_ => 'Boose::Exception::ClassNotFound');
    is $_->class => 'UnlikelyToExist42';
};

try {
    Boose::Loader::load('ClassWithSyntaxErrors');
}
catch {
    ok Boose::Exception->caught($_ => 'Boose::Exception::CantLoadClass');
    is $_->class => 'ClassWithSyntaxErrors';
};

ok Boose::Loader::load('NormalClass');
