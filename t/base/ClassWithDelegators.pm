package ClassWithDelegators;

use Boose;
use Delegator;

has foo => {
    default => sub { Delegator->new },
    handles => [qw/bar set_bar baz/]
};

1;
