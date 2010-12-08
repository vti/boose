package Boose::Loader::Exception;

use base 'Boose::Base';

sub class      { shift->{class} }
sub error      { shift->{error} }
sub has_errors { shift->{has_errors} }
sub not_found  { shift->{not_found} }

sub new {
    my $class = shift;
    my $error = shift;

    my $self = $class->SUPER::new(@_);

    $self->{error} = $error;

    my $class = $self->class;

    if ($error =~ m/\ACan't locate $class in \@INC/) {
        $self->{not_found} = 1;
    }
    else {
        $self->{has_errors} = 1;
    }

    return $self;
}

1;
