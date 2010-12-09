package Bar;
use Boose;

extends 'Boose::Base';

with 'FooRole';

sub required {}

1;
