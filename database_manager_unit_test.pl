#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use lib './';
use database_manager qw(get_users get_user_by_id get_user_by_email add_user remove_user set_users_file);

set_users_file('fake_db_tests.json');

# test n°1 get_users

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
    ],
    "get_users()"
);

# test n°2-3 get_user_by_id

# test n°2 for existing user
is(
    get_user_by_id(1),
    {
        'id' => 1,
        'name' => 'mec',
        'email' => 'mec@example.com'
    },
    "get_user_by_id() for existing user"
);

# test n°3 for non existing user
is(
    get_user_by_id(3),
    undef,
    "get_user_by_id() for non existing user"
);

# test n°4-5 get_user_by_email

# test n°4 for existing user
is(
    get_user_by_email('mec@example.com'),
    {
        'id' => 1,
        'name' => 'mec',
        'email' => 'mec@example.com'
    },
    "get_user_by_id() for existing user"
);

# test n°5 for non existing user
is(
    get_user_by_email('mec3@example.com'),
    undef,
    "get_user_by_id() for non existing user"
);

# test n°6 add_user

# test n°7 remove_user

done_testing();