package Boose::IteratorWithLambdas;
use Boose;

use base 'Boose::Decorator';

sub first {
    my $self = shift;
    my $cb   = shift;

    $self->rewind;

    while (my $el = $self->next) {
        if (my $res = $cb->($self, $el)) {
            return $res;
        }
    }

    $self->rewind;

    return;
}

sub each {
    my $self = shift;
    my $sub  = shift;

    $self->rewind;

    while (my $el = $self->next) {
        $sub->($self, $el);
    }

    $self->rewind;

    return $self;
}

1;
