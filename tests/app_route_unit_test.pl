#!/usr/bin/env perl
use strict;
use warnings;
use Mojo::Base -strict;
use Test::Mojo;
use Test::More;

use lib './lib';

my $t = Test::Mojo->new('myapp');

done_testing();