package Boose::Exception::Base;

use strict;
use warnings;

use base 'Boose::Base';

require Scalar::Util;
require Carp;

use overload '""' => sub { shift->to_string }, fallback => 1;
use overload 'bool' => sub { shift; }, fallback => 1;

__PACKAGE__->attr(message => 'Unknown exception');

sub to_string { shift->message }

sub throw {
    my $class = shift;

    my $e;

    if (Scalar::Util::blessed($class)) {
        $e = $class;
    }
    else {
        $e = $class->new(@_);
    }

    Carp::croak($e);
}

1;
