package Class;
use Boose;

extends 'Boose::Base';

has [qw/foo bar/];
has 'baz';
has 'default';
has 'read_only'    => {is       => 'ro'};
has 'overwritable' => {is       => undef};
has 'weak'         => {weak_ref => 1};

sub new {
    my $self = shift->SUPER::new(@_);

    $self->{default} //= 1;

    return $self;
}

sub overwritable {'123'}

1;
