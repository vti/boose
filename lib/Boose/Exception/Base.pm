package Boose::Exception::Base;

use base 'Boose::Base';

require Carp;

__PACKAGE__->attr(message => 'Exception');

use overload '""' => sub { shift->to_string }, fallback => 1;
use overload 'bool' => sub { shift; }, fallback => 1;

sub throw {
    my $class = shift;
    my $self = ref $class ? $class : $class->new(@_);

    Carp::croak($self);
}

sub to_string { shift->message }

1;
