package database_manager;

use strict;
use warnings;
use JSON;
use Exporter 'import';
use Carp;

our @EXPORT_OK = qw(get_users);

my $users_file = 'fake_db.json';

sub get_users {
    open my $fh, '<', $users_file or return [];
    local $/; # Enable 'slurp' mode to read the whole file at once
    my $json_text = <$fh>;
    close $fh;
    return decode_json($json_text);
}

1;