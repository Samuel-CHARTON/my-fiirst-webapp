package database_manager;

use strict;
use warnings;
use JSON;
use Exporter 'import';
use Carp;

use v5.36;

our @EXPORT_OK = qw(get_users get_user_by_id get_user_by_email add_user remove_user set_users_file);

my $users_file = 'fake_db.json';

sub set_users_file($file) {
    $users_file = $file;
    return;
}

sub validate_email($email) {
    # credits: https://regex101.com/r/gJ7pU0/1
    my $email_regex = qr/
        (?(DEFINE)
            (?<addr_spec> (?&local_part) @ (?&domain) )
            (?<local_part> (?&dot_atom) | (?&quoted_string) | (?&obs_local_part) )
            (?<domain> (?&dot_atom) | (?&domain_literal) | (?&obs_domain) )
            (?<domain_literal> (?&CFWS)? \[ (?: (?&FWS)? (?&dtext) )* (?&FWS)? \] (?&CFWS)? )
            (?<dtext> [\x21-\x5a] | [\x5e-\x7e] | (?&obs_dtext) )
            (?<quoted_pair> \\ (?: (?&VCHAR) | (?&WSP) ) | (?&obs_qp) )
            (?<dot_atom> (?&CFWS)? (?&dot_atom_text) (?&CFWS)? )
            (?<dot_atom_text> (?&atext) (?: \. (?&atext) )* )
            (?<atext> [a-zA-Z0-9!#$%&'*+\/=?^_`{|}~-]+ )
            (?<atom> (?&CFWS)? (?&atext) (?&CFWS)? )
            (?<word> (?&atom) | (?&quoted_string) )
            (?<quoted_string> (?&CFWS)? " (?: (?&FWS)? (?&qcontent) )* (?&FWS)? " (?&CFWS)? )
            (?<qcontent> (?&qtext) | (?&quoted_pair) )
            (?<qtext> \x21 | [\x23-\x5b] | [\x5d-\x7e] | (?&obs_qtext) )
            # comments and whitespace
            (?<FWS> (?: (?&WSP)* \r\n )? (?&WSP)+ | (?&obs_FWS) )
            (?<CFWS> (?: (?&FWS)? (?&comment) )+ (?&FWS)? | (?&FWS) )
            (?<comment> \( (?: (?&FWS)? (?&ccontent) )* (?&FWS)? \) )
            (?<ccontent> (?&ctext) | (?&quoted_pair) | (?&comment) )
            (?<ctext> [\x21-\x27] | [\x2a-\x5b] | [\x5d-\x7e] | (?&obs_ctext) )
            # obsolete tokens
            (?<obs_domain> (?&atom) (?: \. (?&atom) )* )
            (?<obs_local_part> (?&word) (?: \. (?&word) )* )
            (?<obs_dtext> (?&obs_NO_WS_CTL) | (?&quoted_pair) )
            (?<obs_qp> \\ (?: \x00 | (?&obs_NO_WS_CTL) | \n | \r ) )
            (?<obs_FWS> (?&WSP)+ (?: \r\n (?&WSP)+ )* )
            (?<obs_ctext> (?&obs_NO_WS_CTL) )
            (?<obs_qtext> (?&obs_NO_WS_CTL) )
            (?<obs_NO_WS_CTL> [\x01-\x08] | \x0b | \x0c | [\x0e-\x1f] | \x7f )
            # character class definitions
            (?<VCHAR> [\x21-\x7E] )
            (?<WSP> [ \t] )
        )
        ^(?&addr_spec)$
    /x;
    return $email =~ $email_regex;
}

sub get_users() {
    open my $fh, '<', $users_file or return [];
    local $/; # Enable 'slurp' mode to read the whole file at once
    my $json_text = <$fh>;
    close $fh;
    return eval { decode_json($json_text) } // [];
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
    return;
}

sub get_user_by_email($email) {
    my $users = get_users();
    foreach my $user (@$users) {
        if ($user->{email} eq $email) {
            return $user;
        }
    }
    return;
}

sub add_user($name, $email) {

    if ( ! length $email || ! length $name ) { # length undef -> 0 
        return (0, "error username or password empty");
    }

    unless (validate_email($email)) {
        return (0, "error invalid email");
    }

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
    
    return (1, "");
}

sub remove_user($id) {
    #my $users = get_users();

    my $users = [ grep { $_->{id} != $id } get_users()->@* ];
    
    # my $new_users = [];

    # # @$user ou $users->@*
    # # @{ $user->{'another-list'} } ou $user->{'another-list'}->@*
    
    # foreach my $user (@$users) { # []
    #     if ($user->{id} != $id) {
    #         push @$new_users, $user;
    #     }
    # }
    
    open my $fh, '>', $users_file or return 0;
    #print $fh encode_json($new_users);
    close $fh;
    return 1;
}

1;
