package Boose::Meta::Attr;

use strict;
use warnings;

sub new {
    my $class = shift;
    $class = ref $class if ref $class;

    my $self = {@_};
    bless $self, $class;

    $self->{is} = '' unless exists $self->{is};

    return $self;
}

sub name        { $_[0]->{name} }
sub default     { $_[0]->{default} }
sub is          { $_[0]->{is} }
sub is_weak_ref { !!$_[0]->{weak_ref} }

1;
