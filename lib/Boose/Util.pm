package Boose::Util;

use vars qw(@EXPORT @EXPORT_OK $VERSION @ISA);

BEGIN {
    require Exporter;
    @ISA = qw(Exporter);
}

@EXPORT = @EXPORT_OK = qw(class_to_path);

sub class_to_path {
    my $class = shift;

    $class =~ s{::}{/}g;
    $class .= '.pm';

    return $class;
}

1;
