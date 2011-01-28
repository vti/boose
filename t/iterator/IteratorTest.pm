package IteratorTest;

use strict;
use warnings;

use base 'Test::Class';

use Test::More;

use Boose::Iterator;

sub _create_iterator { shift; Boose::Iterator->new(@_) }

sub empty : Test(6) {
    my $self = shift;

    my $i = $self->_create_iterator();

    ok $i;

    is $i->size => 0;
    ok not defined $i->next;
    ok not defined $i->prev;
    ok not defined $i->first;
    ok not defined $i->last;
}

sub size : Test(4) {
    my $self = shift;

    my $i = $self->_create_iterator(1, 2, 3);
    is $i->size => 3;

    $i = $self->_create_iterator(1, 2);
    is $i->size => 2;

    $i = $self->_create_iterator(1);
    is $i->size => 1;

    $i = $self->_create_iterator([1]);
    is $i->size => 1;
}

sub reverse : Test(8) {
    my $self = shift;

    my $i = $self->_create_iterator(3, 2, 1);
    is $i->size => 3;

    $i->reverse;

    my $element = $i->next;
    ok $element;
    is $element => 1;

    $element = $i->next;
    ok $element;
    is $element => 2;

    $element = $i->next;
    ok $element;
    is $element => 3;

    ok not defined $i->next;
}

sub rewind : Test(1) {
    my $self = shift;

    my $i = $self->_create_iterator(1, 2, 3);
    $i->next;

    $i->rewind;

    is $i->next => 1;
}

sub current : Test(3) {
    my $self = shift;

    my $i = $self->_create_iterator(1, 2, 3);

    ok $i->current;
    is $i->current => 1;
    $i->next;
    is $i->current => 1;
}

1;
