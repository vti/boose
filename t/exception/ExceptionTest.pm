package ExceptionTest;

use strict;
use warnings;

use base 'Test::Class';

use Test::More;
use Try::Tiny;

use Exception;
use ClassWithExceptions;

sub throw_unknown : Test(1) {
    try {
        Boose::Exception->throw;
    }
    catch {
        like $_ => qr/Unknown exception/;
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
        like $_->message => qr/Something bad happened/;

        ok(Boose::Exception->caught('Exception'));
        ok !Boose::Exception->caught('Unknown');
    };
}

sub exception_with_default_message : Test(2) {
    try {
        Exception->throw;
    }
    catch {
        like $_->message => qr/Exception raised/;

        ok(Boose::Exception->caught('Exception'));
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

sub throw_string_from_class : Test(1) {
    try {
        ClassWithExceptions->throw_string;
    }
    catch {
        like $_ => qr/foo/;
    };
}

sub throw_object_from_class : Test(2) {
    try {
        ClassWithExceptions->throw_object;
    }
    catch {
        like $_ => qr/bar/;

        ok(Boose::Exception->caught($_ => 'Exception'));
    };
}

1;
