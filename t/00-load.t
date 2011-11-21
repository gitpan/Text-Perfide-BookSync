#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Text::Perfide::BookSync' ) || print "Bail out!\n";
}

diag( "Testing Text::Perfide::BookSync $Text::Perfide::BookSync::VERSION, Perl $], $^X" );
