#____________________________________________________________________ 
# File: MEVO::Service::Protocol.pm
#____________________________________________________________________ 
#  
# Author: Shaun ASHBY <Shaun.Ashby@gmail.com>
# Update: 2010-04-09 18:19:39+0200
# Revision: $Id$ 
#
# Copyright: 2010 (C) Shaun ASHBY
#
#--------------------------------------------------------------------
package MEVO::Service::Protocol;

use Moose;
use namespace::clean -except => 'meta';

has 'type' => (
    is => 'rw',
    isa => 'Str',
    default => sub { "SIAP::Extended" };
    lazy => 1
    );

no Moose;

__PACKAGE__->meta()->make_immutable();

1;

__END__
