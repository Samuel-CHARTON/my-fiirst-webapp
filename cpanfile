use strict;
use warnings;

# Modules required for the application to run
requires "Mojolicious"   => "9.0";   # Minimum version of Mojolicious
requires "JSON::XS"      => 0;       # For handling JSON files
requires "Carp"          => 0;       # For error handling

# Dependencies for tests
on 'test' => sub {
    requires "Test::More"                => 0;  # Standard test module
    requires "Test::Mojo"                => 0;  # Testing tool for Mojolicious
    requires "Test2::Bundle::Extended"   => 0;  # Advanced tests
    requires "Test2::Plugin::NoWarnings" => 0;  # Checks for no warnings
    requires "Test2::Tools::Explain"     => 0;  # Tools to explain tests
    requires "Test2::V0"                 => 0;  # Test2 suite, version V0
};
