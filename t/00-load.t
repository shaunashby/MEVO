#!perl -T

use Test::More tests => 4;

BEGIN {
	use_ok( 'MEVO' );
	use_ok( 'MEVO::Model' );
	use_ok( 'MEVO::Service::Protocol' );
	use_ok( 'Sky::Model' );
	use_ok( 'VO::Model' );
	use_ok( 'VO::Service' );
	use_ok( 'VO::Service::WCS' );
}

diag( "Testing MEVO $MEVO::VERSION, Perl $], $^X" );
