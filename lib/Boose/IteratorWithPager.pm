package Boose::IteratorWithPager;
use Boose;

extends 'Boose::Decorator';

sub next {
    my $self   = shift;
    my $length = shift;

    return $self->get_decorated->next unless $length;

    my @elements;
    foreach (1 .. $length) {
        my $element = $self->next;
        last unless $element;

        push @elements, $element;
    }

    return $self->new($self->get_decorated->new(@elements));
}

sub prev {
    my $self   = shift;
    my $length = shift;

    return $self->get_decorated->prev unless $length;

    $self->prev;

    my @elements;
    foreach (1 .. $length) {
        my $element = $self->prev;
        last unless $element;

        push @elements, $element;
    }

    return $self->new($self->get_decorated->new(@elements));
}

1;
