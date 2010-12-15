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

sub throw_object : Test(1) {
    try {
        Boose::Exception->throw(Exception->new);
    }
    catch {
        like $_ => qr/Exception raised/;
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

sub exception_with_default_message : Test(2) {
    try {
        Exception->throw;
    }
    catch {
        like $_->get_message => qr/Exception raised/;

        ok(Boose::Exception->caught($_ => 'Exception'));
    };
}

sub stringnification : Test(2) {
    try {
        Exception->throw;
    }
    catch {
        like $_ => qr/Exception raised/;

        ok(Boose::Exception->caught($_ => 'Exception'));
    };
}

1;
