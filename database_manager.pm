package database_manager;

use strict;
use warnings;
use JSON;
use Exporter 'import';
use Carp;

our @EXPORT_OK = qw(get_users get_user_by_id);

my $users_file = 'fake_db.json';

sub get_users {
    open my $fh, '<', $users_file or return [];
    local $/; # Enable 'slurp' mode to read the whole file at once
    my $json_text = <$fh>;
    close $fh;
    return decode_json($json_text);
}

sub get_user_by_id {
    my $id = shift; # Get the id from the arguments
    my $users = get_users();
    foreach my $user (@$users) {
        if ($user->{id} == $id) {
            return $user;
        }
    }
    return undef;
}
1;