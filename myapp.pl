#!/usr/bin/env perl
use Mojolicious::Lite -signatures;

use lib './';
use database_manager qw(get_users get_user_by_id get_user_by_email add_user remove_user);

get '/' => sub ($c) {
  $c->render(template => 'index');
};

get '/list' => sub ($c) {
  $c->stash(tab => generate_tab());
  $c->render(template => 'list');
};

sub generate_tab {
  my $users = get_users();
  my $test = ["<div id='name'><p>oui</p></div>"];
  push @$test, "<div id='name'><p>oui</p></div>";
  return $test;
}

app->start;
__DATA__

@@ index.html.ep
% layout 'default';
% title 'Welcome';
<h1>Welcome to the Mojolicious real-time web framework!</h1>

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
  <head><title><%= title %></title></head>
  <body><%= content %></body>
</html>

@@ list.html.ep
<h1>List of Users<h1>
<% foreach my $tabs (@$tab) { %>
  <%== $tabs %>
<% } %>
