package Class;
use Boose;

has [qw/foo bar/];
has 'baz';
has 'default';
has 'read_only' => {is => 'ro'};
has 'overwritable';
has 'weak' => {weak_ref => 1};

sub new {
    my $self = shift->SUPER::new(@_);

    $self->{default} //= 1;

    return $self;
}

sub set_overwritable {
    my $self  = shift;
    my $value = shift;

    $value =~ s/1/one/g;

    $self->set(overwritable => $value);
}

1;
