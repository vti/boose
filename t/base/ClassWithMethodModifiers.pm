package ClassWithMethodModifiers;
use Boose;

sub method {
    my $self = shift;

    $self->{message} .= 'method';
}

around 'method' => sub {
    my $orig = shift;
    my $self = shift;

    $self->{message} .= '_';

    #$self->$orig(@_);
    $orig->($self, @_);

    $self->{message} .= '_';
};

before 'method' => sub {
    my $self = shift;

    $self->{message} .= 'before';
};

after 'method' => sub {
    my $self = shift;

    $self->{message} .= 'after';
};

1;
