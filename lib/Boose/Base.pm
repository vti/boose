package Boose::Base;

use strict;
use warnings;

require Carp;

sub new {
    my $class = shift;
    $class = ref $class if ref $class;

    my $self = {@_};

    bless $self, $class;

    foreach my $key (keys %$self) {
        Carp::croak("Unknown attribute $key") unless $self->can($key);
    }

    $self->BUILD if $self->can('BUILD');

    return $self;
}

1;
