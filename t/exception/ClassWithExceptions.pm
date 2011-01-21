package ClassWithExceptions;

use Boose;
use Exception;

sub throw_string {
    throw 'foo';
}

sub throw_object {
    throw(Exception->new(message => 'bar'));
}

1;
