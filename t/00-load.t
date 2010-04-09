#!perl -T

use Test::More tests => 3;

BEGIN {
	use_ok( 'MEVO' );
	use_ok( 'MEVO::Model' );
	use_ok( 'MEVO::Service::Protocol' );
}

diag( "Testing MEVO $MEVO::VERSION, Perl $], $^X" );
