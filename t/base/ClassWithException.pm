package ClassWithException;
use Boose;

extends 'Boose::Base';

use Exception;

sub mortal {
    Exception->throw(message => 'Error!');
}

1;
