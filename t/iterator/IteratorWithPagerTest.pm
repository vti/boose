package IteratorWithPagerTest;

use strict;
use warnings;

use base 'IteratorTest';

use Test::More;

use Boose::Iterator;
use Boose::IteratorWithPager;

sub _create_iterator {
    shift;
    Boose::IteratorWithPager->new(Boose::Iterator->new(@_));
}

sub empty_pages : Test(4) {
    my $self = shift;

    my $i = $self->_create_iterator();
    ok not defined $i->next(10)->next;
    ok not defined $i->next(10)->prev;
    ok not defined $i->prev(10)->prev;
    ok not defined $i->prev(10)->next;
}

sub next_page : Test() {
    my $self = shift;

    my $i = $self->_create_iterator(1, 2, 3);
    my $page = $i->next(2);
    is $page->size => 2;
}

sub next_page_bigger_than_total_size : Test(5) {
    my $self = shift;

    my $i = $self->_create_iterator(1, 2, 3);

    my $page = $i->next(10);
    ok $page->isa('Boose::IteratorWithPager');
    is $page->size => 3;
    ok not defined $i->next;

    $page = $i->next(10);
    ok $page->isa('Boose::IteratorWithPager');
    is $page->size => 0;
}

sub prev_page : Test(3) {
    my $self = shift;

    my $i = $self->_create_iterator(1, 2, 3);

    $i->next;
    $i->next;
    $i->next;
    ok not defined $i->next;
    my $page = $i->prev(3);
    is $page->size => 2;
    ok not defined $i->prev;
}

sub prev_page_bigger_than_total_size : Test(2) {
    my $self = shift;

    my $i = $self->_create_iterator(1, 2, 3);
    my $page = $i->prev(10);
    is $page->size => 0;
    ok not defined $i->prev;
}

1;
