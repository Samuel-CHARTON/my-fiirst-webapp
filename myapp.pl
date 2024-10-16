#!/usr/bin/env perl
use Mojolicious::Lite -signatures;

use lib './';
use database_manager qw(get_users get_user_by_id get_user_by_email add_user remove_user);

get '/' => sub ($c) {
  $c->render(template => 'index');
};

get '/list' => sub ($c) {
  $c->stash(tab => get_users());
  $c->render(template => 'list');
};

get '/add' => sub ($c) {
  $c->render(template => 'add');
};

post '/add' => sub ($c) {
    my $username = $c->param('username');
    my $email = $c->param('email');

    my $result = add_user($username, $email);
    if ($result == 0) {
      $c->stash(error_msg => 'error username or password empty');
      return $c->render(template => 'add')
    }

    # $c->stash(username => $username, email => $email);
    # $c->render(template => 'add');
    return $c->redirect_to('/list');
};

app->start;

# TODO: A partir de / on ne peut pas naviguer
# TODO: A partir /list on ne peut pas ajouter un user sans connaitre la route
