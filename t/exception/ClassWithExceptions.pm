package ClassWithExceptions;

use Boose;
use Exception;

sub throw_string {
    throw('foo');
}

sub throw_object {
    Exception->throw(message => 'bar');
}

1;
