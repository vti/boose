package Boose::Exception::ClassNotFound;

use base 'Boose::Exception::Base';

__PACKAGE__->attr('class');

sub message {
    my $self = shift;

    my $class = $self->class;
    return "Can't find class '$class'";
}

1;
