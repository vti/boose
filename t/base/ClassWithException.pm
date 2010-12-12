package ClassWithException;
use Boose;

extends 'Boose::Base';

sub mortal {
    throw 'Exception', message => 'Error!';
}

1;
