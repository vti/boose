package Boose::Exception::ClassNotFound;

use base 'Boose::Exception';

__PACKAGE__->attr('class');

__PACKAGE__->attr(
    message => sub {
        my $class = shift->class;
        return "Can't find class '$class'";
    }
);

1;
