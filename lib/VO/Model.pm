#____________________________________________________________________ 
# File: Model.pm
#____________________________________________________________________ 
#  
# Author: Shaun ASHBY <Shaun.Ashby@gmail.com>
# Update: 2009-11-25 13:59:19+0100
# Revision: $Id$ 
#
# Copyright: 2009 (C) Shaun ASHBY
#
#--------------------------------------------------------------------
package VO::Model;
use Moose;
use namespace::clean -except => 'meta';

# Could use "apply_roles" to mix in whichever role (i.e. for a specific VO service) we want

has '_service' => (
    is => 'ro',
    isa => 'VO::Service',
    lazy_build => 1,
    init_args => undef
    );

has 'service_type' => (
    is => 'rw',
    isa => 'Str',
    required => 1
    );

sub query() {}

sub _build__service {
    my $self = shift;

    if (defined($self->{service_type}) && $self->{service_type} =~ //) {
	my $model = "VO::Model::Service::${ $self->{service_type} }";
	$self->{_service} = $model->new() || die "Unable to create service for class $model.\n";
    } else {
	confess "Unknown service type ".$self->{service_type}."\n";
    }
}

no Moose;

1;

__END__
