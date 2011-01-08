package NormalClass;

use strict;
use warnings;

sub new {
    my $class = shift;
    my $hello = shift;

    my $self = {hello => $hello};
    bless $self, $class;

    return $self;
}

sub hello { shift->{hello} || 'unknown' }

1;
