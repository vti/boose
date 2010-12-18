package IteratorTest;

use strict;
use warnings;

use base 'Test::Class';

use Test::More;
use Try::Tiny;

use Exception;

sub throw_object : Test(1) {
    try {
        Boose::Exception->throw(Exception->new);
    }
    catch {
        like $_ => qr/Exception raised/;
    };
}

sub throw_string : Test(1) {
    try {
        Boose::Exception->throw('[foobar]');
    }
    catch {
        like $_ => qr/\[foobar\]/;
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
