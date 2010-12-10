package ClassWithException;
use Boose;

extends 'Boose::Base';

sub mortal {
    Boose::Exception->throw('Exception', message => 'Error!');
    #throw 'Exception', message => 'Error!';
}

1;
