package Boose::Util;

use strict;
use warnings;

use base 'Exporter';

use vars qw(@EXPORT @EXPORT_OK $VERSION @ISA);

@EXPORT = @EXPORT_OK = qw(is_class_loaded class_to_path install_sub);

sub is_class_loaded {
    my $class = shift;

    return 1 if $class->can('new');

    return;
}

sub class_to_path {
    my $class = shift;

    $class =~ s{::}{/}g;
    $class .= '.pm';

    return $class;
}

sub install_sub {
    my $package = shift;
    my $name    = shift;
    my $sub     = shift;

    return if $package->can($name);

    no strict 'refs';
    *{$package . '::' . $name} = $sub;
}

1;
