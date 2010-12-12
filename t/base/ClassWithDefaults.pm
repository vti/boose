package ClassWithDefaults;
use Boose;

extends 'Boose::Base';

has 'num' => {default => 1};
has 'str' => {default => 'Hello'};
has 'array' => {
    default => sub { [qw/1 2 3/] }
};
has 'hash' => {
    default => sub { {foo => 'bar'} }
};

has 'simple' => 2;

1;