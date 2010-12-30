package Boose::Meta::Attr;

use strict;
use warnings;

require Boose::Util;

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

sub set_static_value { $_[0]->{static_value} = $_[1] }
sub static_value { $_[0]->{static_value} }

sub clone {
    my $self = shift;

    my $name        = $self->name;
    my $default     = $self->default;
    my $is          = $self->is;
    my $is_weak_ref = $self->is_weak_ref;

    my $static_value = Boose::Util::clone($self->static_value);

    return $self->new(
        name         => $name,
        default      => $default,
        is           => $is,
        weak_ref     => $is_weak_ref,
        static_value => $static_value
    );
}

1;
