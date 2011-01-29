package Boose::Util;

use strict;
use warnings;

use base 'Exporter';

use vars qw(@EXPORT @EXPORT_OK $VERSION @ISA);

@EXPORT = @EXPORT_OK =
  qw(is_class_loaded class_to_path sub_exists install_sub install_alias modify_sub clone);

use Scalar::Util 'blessed';

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

sub sub_exists {
    my $package = shift;
    my $name = shift;

    no strict 'refs';
    return exists ${"$package\::"}{$name};
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

sub clone {
    my $orig = shift;

    my $dest;

    if (blessed($orig)) {
        die 'TODO';
    }
    elsif (my $ref = ref $orig) {
        if ($ref eq 'HASH') {
            $dest = _clone_hashref($orig);
        }
        elsif ($ref eq 'ARRAY') {
            $dest = _clone_arrayref($orig);
        }
        elsif ($ref eq 'SCALAR') {
            my $tmp = $$orig;
            $dest = \$tmp;
        }
        elsif ($ref eq 'CODE') {
            $dest = $orig;
        }
        else {
            die 'TODO';
        }
    }
    else {
        $dest = $orig;
    }

    return $dest;
}

sub _clone_hashref {
    my $hashref = shift;

    my $dest = {};
    while (my ($key, $value) = each %$hashref) {
        $dest->{$key} = clone($value);
    }

    return $dest;
}

sub _clone_arrayref {
    my $arrayref = shift;

    my $dest = [];
    foreach (@$arrayref) {
        push @$dest, clone($_);
    }

    return $dest;
}
1;
