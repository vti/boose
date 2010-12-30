package Boose;

use strict;
use warnings;

use base 'Boose::Import';

use Boose::Base;
use Boose::Exception;
use Boose::Util qw(install_sub modify_sub);

use Try::Tiny;

our $VERSION = '0.0001';

sub import_finalize {
    my $class   = shift;
    my $package = shift;

    {
        no strict 'refs';
        push @{"$package\::ISA"}, "$class\::Base";
    }

    install_sub($package => with   => \&with);
    install_sub($package => has    => \&has);
    install_sub($package => static => \&static);

    install_sub($package => throw   => \&throw);
    install_sub($package => try     => \&try);
    install_sub($package => catch   => \&catch);
    install_sub($package => finally => \&finally);

    install_sub(
        $package => before => sub { modify_sub($package, 'before', @_) });
    install_sub($package => after => sub { modify_sub($package, 'after', @_) }
    );
    install_sub(
        $package => around => sub { modify_sub($package, 'around', @_) });
}

sub has { caller->attr(@_) }

sub static {
    caller->attr(
        @_ == 2 ? ($_[0], default => $_[1], static => 1) : (@_, static => 1));
}

sub with  { caller->add_role(@_) }
sub throw { Boose::Exception->throw(@_) }

1;
