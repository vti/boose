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

sub delegator : Test(6) {
    my $self = shift;

    my $object = $self->_build;

    is $object->foo->bar => 'bar';
    is $object->foo->baz => 'baz';

    is $object->bar => 'bar';
    is $object->baz => 'baz';

    $object->set_bar('hello');
    is $object->foo->bar => 'hello';
    is $object->bar      => 'hello';
}

1;
