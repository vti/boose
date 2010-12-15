package Boose::Exception::Base;

use base 'Boose::Base';

require Carp;

use overload '""' => sub { shift->to_string }, fallback => 1;
use overload 'bool' => sub { shift; }, fallback => 1;

__PACKAGE__->attr(message => 'Exception');

sub to_string { shift->message }

1;
