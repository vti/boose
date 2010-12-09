package LoaderTest;

use strict;
use warnings;

use base 'Test::Class';

use Test::More;

use Try::Tiny;
use Boose::Loader;

sub normal : Test(1) {
    my $self = shift;

    ok(Boose::Loader::load('NormalClass'));
}

sub not_found : Test(2) {
    try {
        Boose::Loader::load('UnlikelyToExist42');
    }
    catch {
        ok(Boose::Exception->caught($_ => 'Boose::Exception::ClassNotFound'));
        is $_->class => 'UnlikelyToExist42';
    };
}

sub syntax_errors : Test(2) {
    try {
        Boose::Loader::load('ClassWithSyntaxErrors');
    }
    catch {
        ok(Boose::Exception->caught($_ => 'Boose::Exception::CantLoadClass'));
        is $_->class => 'ClassWithSyntaxErrors';
    };
}

1;
