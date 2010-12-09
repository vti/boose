package FooRole;
use Boose::Role;

extends 'Boose::Role::Base';

requires 'required';

sub public     {1}
sub _protected {'I am protected'}

1;
