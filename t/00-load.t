#!perl -T

use Test::More tests => 4;

BEGIN {
	use_ok( 'MEVO' );
	use_ok( 'MEVO::Model' );
	use_ok( 'MEVO::Service::Protocol' );
	use_ok( 'Sky::Model' );
}

diag( "Testing MEVO $MEVO::VERSION, Perl $], $^X" );
