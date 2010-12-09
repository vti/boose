package Boose::Exception::Base;

use base 'Boose::Base';

require Carp;

__PACKAGE__->attr('message');

sub throw {
    my $class = shift;
    my $self = ref $class ? $class : $class->new(@_);

    Carp::croak($self);
}

1;
