package Sky::Model;

use Moose;
use namespace::clean -except => 'meta';

sub search() {
    my ($self,@args) = @_;
}

sub error() {}

no Moose;

__PACKAGE__->meta()->make_immutable();

1;

__END__
