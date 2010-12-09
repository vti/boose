package Boose::Exception::CantLoadClass;

use base 'Boose::Exception::Base';

__PACKAGE__->attr('class');

sub message {
    my $self = shift;

    return "Can't load class ";
}

1;
