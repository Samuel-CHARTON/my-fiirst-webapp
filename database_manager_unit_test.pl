#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use lib './';
use database_manager qw(get_users get_user_by_id get_user_by_email add_user remove_user set_users_file);

set_users_file('fake_db_tests.json');

# test get_users

is(
    get_users(),
    [
        {
        'id' => 1,
        'name' => 'mec',
        'email' => 'mec@example.com'
        },
        {
        'id' => 2,
        'name' => 'mec2',
        'email' => 'mec2@example.com'
        }
    ]
);

# test get_user_by_id

# test get_user_by_email

# test add_user

# test remove_user

done_testing();