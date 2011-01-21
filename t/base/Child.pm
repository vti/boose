package Child;
use Boose 'Class';

has 'foofoo';

sub new {
    my $self = shift->SUPER::new(@_);

    $self->set_foofoo(3) unless defined $self->get_foo;

    return $self;
}

1;
