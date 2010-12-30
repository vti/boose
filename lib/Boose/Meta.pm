package Boose::Meta;

use strict;
use warnings;

require Carp;
use Scalar::Util 'blessed';

use Boose::Meta::Attr;

our %classes;

sub new {
    my $class     = shift;
    my $for_class = shift;

    if ($for_class) {
        foreach my $parent ($class->get_parents($for_class)) {
            if (my $parent_meta = $classes{$parent}) {
                my $meta = __PACKAGE__->new;

                foreach my $name (keys %{$parent_meta->attrs}) {
                    $meta->add_attr(
                        $name => $parent_meta->attr($name)->clone);
                }

                $meta->set_class($for_class);

                return $meta;
            }
        }
    }

    my $self = {class => $for_class, @_};
    bless $self, $class;

    return $self;
}

sub set_class { $_[0]->{class} = $_[1] }

sub add_attr {
    my $self = shift;
    my $name = shift;

    if (blessed($_[0]) && $_[0]->isa('Boose::Meta::Attr')) {
        $self->{attrs}->{$name} = shift;
        return;
    }

    my $args = {};

    if (@_ == 1) {
        if (ref $_[0] eq 'HASH') {
            $args = $_[0];
        }
        else {
            $args = {default => $_[0]};
        }
    }
    else {
        $args = {@_};
    }

    my $default = $args->{default};

    Carp::croak('Default value must be a SCALAR or CODEREF')
      if ref $default && ref $default ne 'CODE';

    $self->{attrs}->{$name} = $self->_build_attr(name => $name, %$args);
}

sub attr  { $_[0]->{attrs}->{$_[1]} }
sub attrs { $_[0]->{attrs} }

sub attr_exists {
    my $self = shift;
    my $name = shift;

    return !!exists $self->{attrs}->{$name};
}

sub get_parents {
    my $class     = shift;
    my $for_class = shift;

    my @parents;

    no strict 'refs';

    # shift our class name
    foreach my $sub_class (@{"${for_class}::ISA"}) {
        if ($sub_class->isa('Boose::Base')) {
            push @parents, $class->get_parents($sub_class);
        }
    }

    return $for_class, @parents;
}

sub _build_attr { shift; Boose::Meta::Attr->new(@_) }

1;
