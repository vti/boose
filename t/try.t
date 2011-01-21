#!/usr/bin/env perl

package Foo;
use Boose;

has 'foo';

sub mortal {
    my $self = shift;

    my $rs = '';

    try {
        die 'I am mortal!';
    }
    catch {
        $rs .= $_;
    }
    finally {
        $rs .= 'Yeah';
    };

    return $rs;
}

package main;

use Test::More tests => 1;

my $foo = Foo->new;
like $foo->mortal => qr/I am mortal.*?Yeah/ms;
