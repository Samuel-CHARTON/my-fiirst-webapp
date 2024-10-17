#!/usr/bin/env perl
use strict;
use warnings;

use Test2::V0;

use JSON;
use Carp;

use v5.36;

use lib './lib';
use database_manager qw(get_users get_user_by_id get_user_by_email add_user remove_user set_users_file);

# initiate the content of the test db and set database manager to use this file as db
sub init_tests($test_db, $nb_users) {
    my $base_content = [];

    open my $fh, '>', $test_db or croak "Can't open $test_db: $!";

    for my $i (1..$nb_users) {
        push @$base_content, {
                email => "mec$i\@example.com",
                name => "mec$i",
                id => $i
            };    
    };
    print $fh encode_json($base_content);
    close($fh);
    set_users_file($test_db);
};


init_tests('fake_db_tests.json', 2); # initiate db with 2 users


# test n°1 get_users

is(
    get_users(),
    [
        {
            'id' => 1,
            'name' => 'mec1',
            'email' => 'mec1@example.com'
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
        'name' => 'mec1',
        'email' => 'mec1@example.com'
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
    get_user_by_email('mec1@example.com'),
    {
        'id' => 1,
        'name' => 'mec1',
        'email' => 'mec1@example.com'
    },
    "get_user_by_id() for existing user"
);

# test n°5 for non existing user
is(
    get_user_by_email('mec3@example.com'),
    undef,
    "get_user_by_id() for non existing user"
);

# test n°6-7-8 add_user

# test n°6 test if samuel is not in the base
isnt(
    get_user_by_email('samuel@oui.fr'), 
        {
            name => 'samuel',
            id => 3,
            email => 'samuel@oui.fr'
        },
        "samuel n'est pas dans la base"
);

# test n°7 test if add_user returns 1
my ($status, $id_or_msg) = add_user('samuel', 'samuel@oui.fr');
ok(
    $status == 1,
    "add_user() returned 1"
);
is(
    $id_or_msg,
    "",
    "add_user() returned no message"
);


# tests n°7.5 test if add_user returns 0 and error message when eather name, email empty and if email bad
($status, $id_or_msg) = add_user('', '');
ok(
    $status == 0,
    'add_user(both empty) returned 0'
);
is(
    $id_or_msg,
    'error username or password empty',
    "Error message returned for both fields empty"
);

($status, $id_or_msg) = add_user('sa', '');
ok(
    $status == 0,
    'add_user(name filled, email empty) returned 0'
);
is(
    $id_or_msg,
    'error username or password empty',
    "Error message returned for email empty"
);

($status, $id_or_msg) = add_user('', 'aa@aa.aa');
ok(
    $status == 0,
    'add_user(email filled, name empty) returned 0'
);
is(
    $id_or_msg,
    'error username or password empty',
    "Error message returned for name empty"
);

($status, $id_or_msg) = add_user('samuel', 'samuel@oui.fr');
ok(
    $status == 1,
    "add_user() with valid email succeeded"
);
is(
    $id_or_msg,
    "",
    "add_user() with valid email returned no error message"
);

($status, $id_or_msg) = add_user('samuel', 'invalid-email');
ok(
    $status == 0,
    'add_user() with invalid email failed'
);
is(
    $id_or_msg,
    'error invalid email',
    'The error message for invalid email is correct'
);


# test n°8 test if samuel has been added in the base
is(
    get_user_by_email('samuel@oui.fr'), 
    {
        name => 'samuel',
        id => 3,
        email => 'samuel@oui.fr'
    },
    "samuel est dans la base" 
);

# test n°9-10-11 remove_user

# test n°9 test if samuel is not in the base
is(
    get_user_by_email('samuel@oui.fr'), 
    {
        name => 'samuel',
        id => 3,
        email => 'samuel@oui.fr'
    },
    "samuel est dans la base" 
);

# test n°10 test if add_user returns 1
my $user_id = get_user_by_email('samuel@oui.fr')->{id};
ok(
    remove_user($user_id),
    "is remove_user() returned 1"
);

# test n°11 test if samuel has been added in the base
isnt(
    get_user_by_email('samuel@oui.fr'), 
        {
            name => 'samuel',
            id => 3,
            email => 'samuel@oui.fr'
        },
        "samuel n'est pas dans la base"
);

done_testing();