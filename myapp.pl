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
<h1>List of Users</h1>
<table>
  <tr>
    <td>
      id
    </td>
    <td>
      name
    </td>
    <td>
      email
    </td>
  </tr>
<% foreach my $tabs (@$tab) { %>
  <tr>
    <td>
      <%== $tabs->{id} %>
    </td>
    <td>
      <%== $tabs->{name} %>
    </td>
    <td>
      <%== $tabs->{email} %>
    </td>
  </tr>
<% } %>
</table>