package IteratorWithLambdasTest;

use strict;
use warnings;

use base 'IteratorTest';

use Test::More;

use Boose::Iterator;
use Boose::IteratorWithLambdas;

sub _create_iterator {
    shift;
    Boose::IteratorWithLambdas->new(Boose::Iterator->new(@_));
}

sub empty : Test(2) {
    my $self = shift;

    my $i = $self->_create_iterator;
    is $i->size => 0;
    ok not defined $i->first(sub { $_[1] eq 'foo' ? $_[1] : undef });
}

sub first : Test(2) {
    my $self = shift;

    my $i = $self->_create_iterator(qw/foo bar baz/);
    is $i->size => 3;
    is $i->first(sub { $_[1] eq 'bar' ? $_[1] : undef }) => 'bar';
}

sub each : Test(1) {
    my $self = shift;

    my $i = $self->_create_iterator(1, 2, 3);
    my $sum = 0;
    $i->each(sub { $sum += $_[1] });
    is $sum => 6;
}

1;
