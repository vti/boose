package LoaderTest;

use strict;
use warnings;

use base 'Test::Class';

use Test::More;

use Try::Tiny;
use Boose::Loader;
use Boose::Exception;

sub normal : Test(1) {
    my $self = shift;

    ok(Boose::Loader::load('NormalClass'));
}

sub not_found : Test(3) {
    try {
        Boose::Loader::load('UnlikelyToExist42');
    }
    catch {
        ok(Boose::Exception->caught($_ => 'Boose::Exception::ClassNotFound'));
        like $_->message => qr/Can't find class 'UnlikelyToExist42'/;
        is $_->get_class => 'UnlikelyToExist42';
    };
}

sub syntax_errors : Test(3) {
    try {
        Boose::Loader::load('ClassWithSyntaxErrors');
    }
    catch {
        ok(Boose::Exception->caught($_ => 'Boose::Exception::CantLoadClass'));
        like $_->message => qr/Can't load class 'ClassWithSyntaxErrors'/;
        is $_->get_class => 'ClassWithSyntaxErrors';
    };
}

1;
