package myapp;

use strict;
use warnings;
use Mojo::Base 'Mojolicious', -signatures;

use lib './lib';
use database_manager qw(get_users get_user_by_id get_user_by_email add_user remove_user);

sub startup ($self) {

    # Routes
    my $r = $self->routes;

    $r->get('/' => sub ($c) {
        $c->render(template => 'index');
    });

    $r->get('/list' => sub ($c) {
        $c->stash(tab => get_users());
        $c->render(template => 'list');
    });

    $r->get('/add' => sub ($c) {
        $c->render(template => 'add');
    });

    $r->post('/add' => sub ($c) {
        my $username = $c->param('username');
        my $email = $c->param('email');

        my $result = add_user($username, $email);
        if ($result == 0) {
            $c->stash(error_msg => 'error username or password empty');
            return $c->render(template => 'add');
        }

        return $c->redirect_to('/list');
    });
}

1;

