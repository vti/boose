#!/usr/bin/env perl

use 5.010000;

use strict;
use warnings;

use ExtUtils::MakeMaker;

my ($mm) = $ExtUtils::MakeMaker::VERSION =~ /^([^_]+)/;

WriteMakefile(
    NAME         => 'Boose',
    VERSION_FROM => 'lib/Boose.pm',
    ABSTRACT     => 'Boose',
    AUTHOR       => 'Viacheslav Tykhanovskyi <vti@cpan.org>',

    ($mm < 6.3002 ? () : ('LICENSE' => 'artistic_2')),

    (   $mm < 6.46
        ? ()
        : ( META_MERGE => {
                requires  => {perl => '5.008007'},
                resources => {
                    license    => 'http://dev.perl.org/licenses/',
                    repository => 'http://github.com/vti/boose',
                    bugtracker => 'http://github.com/vti/boose/issues'
                },
                no_index => {directory => [qw/t/]}
            },
            META_ADD => {
                build_requires     => {},
                configure_requires => {}
            },
        )
    ),

    PREREQ_PM => {
        'Carp'         => 0,
        'Exporter'     => 0,
        'Scalar::Util' => 0,
        'Test::More'   => 0,
        'Try::Tiny'    => 0,
    },
    test => {TESTS => 't/*.t t/*/*.t'}
);
