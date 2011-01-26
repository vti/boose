package ClassWithDelegators;

use Boose;
use Delegator;

has foo => {
    default => sub { Delegator->new },
    handles => [qw/bar baz/]
};

1;
