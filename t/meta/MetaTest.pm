package MetaTest;

use strict;
use warnings;

use base 'Test::Class';

use Test::More;

use Boose::Meta;

sub _build_object { shift; Boose::Meta->new('Boose::Base', @_) }

sub constructor : Test(1) {
    my $self = shift;

    my $object = $self->_build_object;

    ok $object->isa('Boose::Meta');
}

sub add_attr : Test(3) {
    my $self = shift;

    my $meta = $self->_build_object;

    $meta->add_attr('foo');

    ok $meta->attr_exists('foo');
    ok $meta->attr('foo');
    is $meta->attr('foo')->name => 'foo';
}

sub add_attr_with_args : Test(3) {
    my $self = shift;

    my $meta = $self->_build_object;

    $meta->add_attr('foo' => 1);
    is $meta->attr('foo')->default => 1;
}

1;
