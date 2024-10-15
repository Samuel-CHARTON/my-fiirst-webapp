#!/usr/bin/perl
use lib './';
use strict;
use warnings;
use Data::Dumper;
use database_manager qw(get_users get_user_by_id);

# test get_users
my $users = get_users();
print "Current users:\n";
print Dumper($users);

# test get_user_by_id
my $user = get_user_by_id(1);
print "User with id 1:\n";
print Dumper($user);