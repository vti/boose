package Child;
use Boose;

extends 'Class';

has 'foofoo';

sub new {
    my $self = shift->SUPER::new(@_);

    $self->{foofoo} //= 3;

    return $self;
}

1;
