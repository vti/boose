package ClassWithException;
use Boose;

use Exception;

sub mortal {
    Exception->throw(message => 'Error!');
}

1;
