package Boose::Meta;

use strict;
use warnings;

require Carp;
require Storable;

use Boose::Meta::Attr;

our %classes;

sub new {
    my $class = shift;
    my $for_class = shift;

    foreach my $parent (_get_parents($for_class)) {
        if (my $parent_meta = $classes{$parent}) {
            my $meta = Storable::dclone($parent_meta);

            $meta->set_class($for_class);

            return $meta;
        }
    }

    my $self = {class => $for_class, @_};
    bless $self, $class;

    return $self;
}

sub set_class { $_[0]->{class} = $_[1] }

sub add_attr {
    my $self = shift;
    my ($name, $args) = @_;

    Carp::croak("Attribute '$name' already exists")
      if exists $self->{attrs}->{$name};

    $args ||= {};
    $args = {default => $args} if ref $args ne 'HASH';

    my $default = $args->{default};

    Carp::croak('Default value must be a SCALAR or CODEREF')
      if ref $default && ref $default ne 'CODE';

    $self->{attrs}->{$name} = Boose::Meta::Attr->new(name => $name, %$args);
}

sub attr { $_[0]->{attrs}->{$_[1]} }

sub attr_exists {
    my $self = shift;
    my $name = shift;

    return !!exists $self->{attrs}->{$name};
}

sub _get_parents {
    my $class = shift;
    my @parents;

    no strict 'refs';

    # shift our class name
    foreach my $sub_class (@{"${class}::ISA"}) {
        push(@parents, _get_parents($sub_class))
          if ($sub_class->isa('Boose::Base'));
    }

    return $class, @parents;
}

1;
