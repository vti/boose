package Boose::Iterator;

use Boose;

sub new {
    my $self = shift->SUPER::new;

    $self->set_elements(@_);

    return $self;
}

sub BUILD { shift->rewind }

sub set_elements {
    my $self = shift;

    my $elements = @_ == 0 ? [] : ref $_[0] eq 'ARRAY' ? $_[0] : [@_];
    $self->{elements} = $elements;
}

sub rewind { shift->{index} = 0 }

sub reverse {
    my $self = shift;

    $self->{elements} = [reverse @{$self->{elements}}];

    return $self;
}

sub size { scalar @{shift->{elements} || []} }

sub first { shift->{elements}->[0] }
sub last  { shift->{elements}->[-1] }

sub current {
    my $self = shift;

    my $index = $self->{index};
    $index-- if $index;

    return $self->{elements}->[$index];
}

sub take_next {
    my $self = shift;

    return unless $self->has_next;

    return $self->{elements}->[$self->{index}];
}

sub take_prev {
    my $self = shift;

    return if $self->{index} < 2;

    return $self->{elements}->[$self->{index} - 2];
}

sub has_next {
    my $self = shift;

    return $self->{index} < $self->size ? 1 : 0;
}

sub has_prev {
    my $self = shift;

    return $self->{index} > 0 ? 1 : 0;
}

sub next {
    my $self = shift;

    return unless $self->has_next;

    return $self->{elements}->[$self->{index}++];
}

sub prev {
    my $self = shift;

    return unless $self->has_prev;

    return $self->{elements}->[--$self->{index}];
}

1;
