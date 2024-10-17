#!/usr/bin/env perl
use strict;
use warnings;
use Mojo::Base -strict;
use Test::Mojo;
use Test::More;

use lib './lib';

my $t = Test::Mojo->new('myapp');

use v5.36;
use Carp;

use JSON;

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

# Test index page
$t->get_ok('/')
  ->status_is(200)
  ->content_like(qr/Welcome to the Mojolicious real-time web framework/);

# Test list page with valid user
$t->post_ok('/add' => form => { username => 'Samuel', email => 'samuel@oui.fr' })
  ->status_is(302)
  ->header_is('Location' => '/list');

# Follow redirect to list page
$t->get_ok('/list')
  ->status_is(200)
  ->content_like(qr/Samuel/);

# Test list page with invalid user
$t->post_ok('/add' => form => { username => '', email => '' })
  ->status_is(200)
  ->content_like(qr/error/);

$t->post_ok('/add' => form => { username => 'samuel', email => '' })
  ->status_is(200)
  ->content_like(qr/error/);

$t->post_ok('/add' => form => { username => '', email => 'samuel@oui.fr' })
  ->status_is(200)
  ->content_like(qr/error/);

# Test non existing page
$t->get_ok('/fake')
  ->status_is(404);

done_testing();