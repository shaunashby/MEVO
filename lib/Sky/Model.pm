package Sky::Model;

use Moose;
use namespace::clean -except => 'meta';

no Moose;

__PACKAGE__->meta()->make_immutable();

1;

__END__
