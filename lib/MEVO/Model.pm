package MEVO::Model;

use Moose;
use namespace::clean -except => 'meta';

use MEVO::Service::Protocol;

has 'protocol' => (
    is => 'rw',
    isa => 'MEVO::Service::Protocol',
    default => sub { return MEVO::Service::Protocol->new( { type => 'SIAP' } ) },
    lazy => 1
    );

no Moose;

__PACKAGE__->meta()->make_immutable();

1;

__END__
