package Boose::Exception::CantLoadClass;

use base 'Boose::Exception::Base';

__PACKAGE__->attr('class');
__PACKAGE__->attr('description');

__PACKAGE__->attr(
    message => sub {
        my $self = shift;

        my $class       = $self->class;
        my $description = $self->description;
        return "Can't load class '$class': $description";
    }
);

1;
