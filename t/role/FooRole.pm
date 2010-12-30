package FooRole;
use Boose::Role;

requires 'required';

sub public     {1}
sub _protected {'I am protected'}

1;
