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

    add_user($username, $email);

    # $c->stash(username => $username, email => $email);
    # $c->render(template => 'add');
    return $c->redirect_to('/list');
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

@@ add.html.ep
<!--
#https://dev.to/akuks/forms-and-fields-in-mojolicous-1ng0 + gpt
-->
<h1>Add an user</h1>
%= form_for add => (method => 'POST') => begin
    %= label_for username => 'Username:'
    %= text_field 'username', id => 'username'
    %= label_for email => 'email:'
    %= password_field 'email', id => "email"
    %= submit_button 'add'
% end
<!--
<% if (stash('username') && stash('email')) { %>
  <p>Username: <%= stash('username') %></p>
  <p>email: <%= stash('email') %></p>
<% } %>
-->