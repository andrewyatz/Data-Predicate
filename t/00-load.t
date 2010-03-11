#!/usr/bin/env perl

use Test::More tests => 1;

BEGIN {
    use_ok( 'Data::Predicate' );
}

diag( "Testing Predicates $Data::Predicate::VERSION, Perl $], $^X" );
