# NB: Contains some pseudo code:
package MEVO;

use warnings;
use strict;

our $VERSION = 0.01;

use Sky::Model;

# Flesh out the call model:
sub handler() {
    my $request = shift;
    
    my $result = Sky::Model->search('VO::Service::Cutout',{ POS     =>  [ split(",",$request->param('POS')) ],
							    SIZE    =>  $request->param('SIZE'),
							    FORMAT  =>  $request->param('FORMAT') });
    # Return DECLINED or maybe a VO::Table::Error object:
    if ($result->error) {
	log("there was an error: ",$result->error);
	return Apache::DECLINED;
    }
    
    return $result;
}

1;
