#!/usr/bin/env perl
use lib './';
use strict;
use warnings;
use Data::Dumper;
use database_manager qw(get_users get_user_by_id get_user_by_email add_user remove_user);

# test get_users
my $users = get_users();
print "Current users:\n";
print Dumper($users);

# test get_user_by_id
my $user = get_user_by_id(1);
print "User with id 1:\n";
print Dumper($user);

# test get_user_by_email
$user = get_user_by_email('mec2@example.com');
print "User with email mec2\@example.com:\n";
print Dumper($user);

# test add_user
add_user('mec3', 'mec3@gmail.com');
$users = get_users();
print "Users after adding mec3:\n";
print Dumper($users);

# test remove_user
remove_user(3);
$users = get_users();
print "Users after removing user with id 3:\n";
print Dumper($users);