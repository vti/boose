package Class;
use Boose;

extends 'Boose::Base';

has [qw/foo bar/];
has 'baz';
has 'default';
has 'read_only' => {is => 'ro'};
has 'overwritable' => {is => undef};

sub new {
    my $self = shift->SUPER::new(@_);

    $self->{default} //= 1;

    return $self;
}

sub overwritable { '123' }

1;
