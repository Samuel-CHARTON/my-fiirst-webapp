#!/usr/bin/perl
use lib './';
use strict;
use warnings;
use Data::Dumper;
use database_manager qw(get_users);

# test get_users
my $users = get_users();
print "Current users:\n";
print Dumper($users);