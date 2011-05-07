package VO::Service;

use strict;
use warnings;

use Carp qw(croak confess);

=pod
  
=head1 NAME

VO::Service - Access to VO services.

=head1 SYNOPSIS

my $vointerface = VO::Service->new(%params);

my $votable = $vointerface->query($type,$coords);

=head1 DESCRIPTION

This module provides a single layer through which an application can access either
cutout or pointed VO services. A client can issue a query for a type of product
(e.g. an image, a light curve or spectra) for a given source (i.e. set of galactic
coordinates). The main reason for using this layer is to avoid having to first ask
the service whether it has any cached images present for the input coordinates, only
to send a second request to generate images using the cutout service. The user simply
says "I want images/light curves/spectra for this source/position" and gets a VOTable
XML object in the response which either contains a VOError (indicating no data or some
other problem) or a valid VOTable containing the VO parameters for the requested input.

=cut
    
use overload q{""} => \&stringify;

sub stringify() {
	my ($self) = @_;
	return "[".__PACKAGE__."]: VO query type ->".$self->type.", coords ".
	    join(": ",@{$self->{options}->{coords}});
}

sub new() {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $params = (@_ == 0) ?             # Error if no params given
	croak("No params given.\n")
	: (ref($_[0]) eq 'HASH') ? $_[0] # Got hashref already - OK
	: { @_ };                        # Otherwise, store the params in a hash
    return bless { options => $params } => $class;
}

sub type() { shift->{options}->{type} || croak("No VO type.\n") }

sub coords() { shift->{options}->{coords} || croak("No coordinates supplied.\n") }

sub query() { croak("This method must be provided by subclasses.\n") }

1;

__END__

=head1 AUTHOR

Shaun ASHBY <shaun.ashby@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2006-2009 by Shaun ASHBY.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
