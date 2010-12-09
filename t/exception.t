#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 7;

use lib 't/lib';

use_ok('Boose::Exception');

use ExceptionWithWrongAttribute;

use Try::Tiny;

try {
    Boose::Exception->throw('Foo');
}
catch {
    like $_ => qr/Can't locate/;
};

try {
    ExceptionWithWrongAttribute->throw(foo => 'bar');
}
catch {
    like $_ => qr/Unknown attribute/;
};

try {
    ExceptionWithWrongAttribute->new(foo => 'bar')->throw;
}
catch {
    like $_ => qr/Unknown attribute/;
};

try {
    Boose::Exception->throw('Exception', message => 'Something bad happened');
}
catch {
    like $_->message => qr/Something bad happened/;

    ok(Boose::Exception->caught($_ => 'Exception'));
    ok !Boose::Exception->caught($_ => 'Unknown');
};
