package Boose::Exception::CantLoadClass;

use base 'Boose::Exception::Base';

__PACKAGE__->attr('class');

sub message {
    my $self = shift;

    my $class = $self->class;
    return "Can't load class '$class'";
}

1;
