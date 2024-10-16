package database_manager;

use strict;
use warnings;
use JSON;
use Exporter 'import';
use Carp;

use feature 'signatures';
no warnings 'experimental::signatures';

our @EXPORT_OK = qw(get_users get_user_by_id get_user_by_email add_user remove_user set_users_file);

my $users_file = 'fake_db.json';

# TODO: database_manager.pm pourrais aussi beneficier de fonction signature en utlisant par example v5.36

sub set_users_file($file) {
    $users_file = $file;
}

sub get_users() {
    open my $fh, '<', $users_file or return [];
    local $/; # Enable 'slurp' mode to read the whole file at once
    my $json_text = <$fh>;
    close $fh;
    return decode_json($json_text);
}

sub get_last_id() {
    my $users = get_users();
    my $max_id = 0;
    foreach my $user (@$users) {
        if ($user->{id} > $max_id) {
            $max_id = $user->{id};
        }
    }
    return $max_id;
}

sub get_user_by_id($id) {
    my $users = get_users();
    foreach my $user (@$users) {
        if ($user->{id} == $id) {
            return $user;
        }
    }
    return undef;
}

sub get_user_by_email($email) {
    my $users = get_users();
    foreach my $user (@$users) {
        if ($user->{email} eq $email) {
            return $user;
        }
    }
    return undef;
}

sub add_user($name, $email) {
    # arg 1: name, arg 2: email
    my $users = get_users();
    my $new_id = get_last_id() + 1;
    my $new_user = {
        id => $new_id,
        name => $name,
        email => $email
    };
    push @$users, $new_user;
    open my $fh, '>', $users_file or return 0;
    print $fh encode_json($users);
    close $fh;
    return 1;
}

sub remove_user($id) {
    my $users = get_users();
    my $new_users = [];
    foreach my $user (@$users) {
        if ($user->{id} != $id) {
            push @$new_users, $user;
        }
    }
    open my $fh, '>', $users_file or return 0;
    print $fh encode_json($new_users);
    close $fh;
    return 1;
}

1;