package Boose::Role::Base;

use strict;
use warnings;

use Boose::Util 'install_sub';

require Carp;

sub check_required_methods {
    my $class   = shift;
    my $package = shift;

    my @methods = $class->require_methods;

    foreach my $method (@methods) {
        if (!$package->can($method)) {
            Carp::croak(
                "Method '$method' is required for using role '$class'");
        }
    }
}

sub import_methods {
    my $class   = shift;
    my $package = caller;

    my $symtable = do { no strict 'refs'; \%{"$class\::"} };

    foreach my $method (keys %$symtable) {
        next if $method =~ m/\A_/;
        next if $method =~ m/\A[A-Z]/;
        next if grep { $_ eq $method } (
            qw/
              version import isa
              extends install_sub
              check_required_methods import_methods require_methods
              /
        );

        install_sub($package => $method => \&{"$class\::$method"});
    }
}

sub require_methods {
    my $class = shift;

    no strict;

    if (@_) {
        *{"$class\::REQUIRES"} = [];
        return;
    }

    return @{*{"$class\::REQUIRES"} || []};
}

1;
