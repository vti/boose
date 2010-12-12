package Boose::Util;

use strict;
use warnings;

use base 'Exporter';

use vars qw(@EXPORT @EXPORT_OK $VERSION @ISA);

@EXPORT = @EXPORT_OK =
  qw(is_class_loaded class_to_path install_sub install_alias modify_sub);

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

sub install_alias {
    my $package = shift;
    my ($alias, $name) = @_;

    no strict 'refs';
    *{"$package\::$alias"} = *{"$package\::$name"};
}

sub install_sub {
    my $package = shift;
    my $name    = shift;
    my $sub     = shift;

    return if $package->can($name);

    no strict 'refs';
    *{$package . '::' . $name} = $sub;
}

sub delete_sub {
    my $package = shift;
    my $name    = shift;

    no strict 'refs';
    my $stash = \%{"$package\::"};
    return delete $stash->{$name};
}

sub modify_sub {
    my $package = shift;
    my $type    = shift;
    my $name    = shift;
    my $sub     = shift;

    Carp::croak("Unknown method '$name'") unless $package->can($name);

    my $orig = delete_sub($package, $name);

    if ($type eq 'before') {
        install_sub(
            $package,
            $name => sub {
                my @args = @_;
                $sub->(@args);
                $orig->(@args);
            }
        );
    }
    elsif ($type eq 'after') {
        install_sub(
            $package,
            $name => sub {
                my @args = @_;
                $orig->(@args);
                $sub->(@args);
            }
        );
    }
    elsif ($type eq 'around') {
        install_sub(
            $package,
            $name => sub {
                $sub->($orig, @_);
            }
        );
    }
}

1;
