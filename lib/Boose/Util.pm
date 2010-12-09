package Boose::Util;

use vars qw(@EXPORT @EXPORT_OK $VERSION @ISA);

BEGIN {
    require Exporter;
    @ISA = qw(Exporter);
}

@EXPORT = @EXPORT_OK = qw(is_class_loaded class_to_path);

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

1;
