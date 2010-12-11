package IteratorTest;

use strict;
use warnings;

use base 'Test::Class';

use Test::More;
use Try::Tiny;

use Exception;

sub cant_find_exception_class : Test(1) {
    try {
        Boose::Exception->throw('Foo');
    }
    catch {
        like $_ => qr/Can't locate/;
    };
}

sub cant_create_exception_object : Test(1) {
    try {
        Exception->throw(foo => 'bar');
    }
    catch {
        like $_ => qr/Unknown attribute/;
    };
}

sub exception_via_loader : Test(3) {
    try {
        Boose::Exception->throw('Exception',
            message => 'Something bad happened');
    }
    catch {
        like $_->get_message => qr/Something bad happened/;

        ok(Boose::Exception->caught($_ => 'Exception'));
        ok !Boose::Exception->caught($_ => 'Unknown');
    };
}

sub exception_directly : Test(3) {
    try {
        Exception->throw(message => 'Something bad happened');
    }
    catch {
        like $_->get_message => qr/Something bad happened/;

        ok(Boose::Exception->caught($_ => 'Exception'));
        ok !Boose::Exception->caught($_ => 'Unknown');
    };
}

1;
