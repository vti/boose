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
sub is_static   { !!$_[0]->{static} }
sub handles     { $_[0]->{handles} }

sub set_static_value { $_[0]->{static_value} = $_[1] }

sub static_value {
    my $self = shift;

    return unless $self->is_static;

    return $self->{static_value} if exists $self->{static_value};

    my $default = $self->default;
    $default = $default->($self) if ref $default eq 'CODE';

    return $self->{static_value} = $default;
}

sub clone {
    my $self = shift;

    my $name        = $self->name;
    my $default     = $self->default;
    my $is          = $self->is;
    my $is_weak_ref = $self->is_weak_ref;

    my $static_value =
      $self->is_static ? Boose::Util::clone($self->static_value) : undef;

    return $self->new(
        name         => $name,
        default      => $default,
        is           => $is,
        weak_ref     => !!$is_weak_ref,
        static       => $self->is_static,
        static_value => $static_value
    );
}

1;
