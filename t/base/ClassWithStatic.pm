package ClassWithStatic;
use Boose;

extends 'Boose::Base';

static 'state';
static 'default' => sub { {} };

1;
