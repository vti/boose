#!/usr/bin/env perl

use lib 't/lib';

use TestLoader qw(t/exception);

Test::Class->runtests;
