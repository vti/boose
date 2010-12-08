package Boose::IteratorWithPager;
use Boose;

use base 'Boose::Decorator';

sub next {
    my $self   = shift;
    my $length = shift;

    return $self->decorated->next unless $length;

    my @elements;
    foreach (1 .. $length) {
        my $element = $self->next;
        last unless $element;

        push @elements, $element;
    }

    return $self->new($self->decorated->new(@elements));
}

sub prev {
    my $self   = shift;
    my $length = shift;

    return $self->decorated->prev unless $length;

    $self->prev;

    my @elements;
    foreach (1 .. $length) {
        my $element = $self->prev;
        last unless $element;

        push @elements, $element;
    }

    return $self->new($self->decorated->new(@elements));
}

1;
