package DelegationTest;

use strict;
use warnings;

use base 'Test::Class';

use Test::More;
use Try::Tiny;

use ClassWithDelegators;
use Delegator;

sub _build           { shift; ClassWithDelegators->new(@_) }
sub _build_delegator { shift; Delegator->new(@_) }

sub delegator : Test(7) {
    my $self = shift;

    my $object = $self->_build;

    is $object->foo->bar => 'bar';
    is $object->foo->baz => 'baz';

    is $object->bar => 'bar';
    is $object->baz => 'baz';

    isa_ok($object->set_bar('hello'), 'ClassWithDelegators');
    is $object->foo->bar => 'hello';
    is $object->bar      => 'hello';
}

1;
