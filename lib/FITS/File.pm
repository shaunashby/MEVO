package FITS::File;

use Moose;
use Moose::Util::TypeConstraints;

use Astro::FITS::CFITSIO;
use Astro::FITS::Header::CFITSIO;

has 'name' => (
    is => 'rw',
    isa => 'Str'
    );

has 'type' => (
    is => 'rw',
    predicate => 'has_image'
    );

has 'header' => (
    is => 'ro',
    isa => 'Astro::FITS::Header::CFITSIO',
    lazy => 1,
    default => sub {
	return Astro::FITS::Header::CFITSIO->new( File => shift->{name} ) || confess "Unable to open FITS file!\n";
        }
    );

has 'raw_image_ptr' => (
    is => 'ro',
    lazy => 1,
    default => sub {
	my ($self) = @_ ;
	($self->has_image) ? return $self->{imagefile} : undef ; }
    );

has 'header_keywords' => (
    is => 'ro',
    isa => 'ArrayRef[Astro::FITS::Header::Item]',
    lazy => 1,
    default => sub { return [ shift->{header}->allitems ] }
    );

# There must be a way to define an accessor like this, make it 'rw' and
# be able to specify a build. Not sure how just at the moment:
sub value_from_header() {
    my ($self,$keyname) = @_;
    return $self->{header}->value($keyname) || confess "No key $keyname found!\n";
}

# The build routine for this class:
sub BUILD {
    my ($self,$params) = @_;

    if ($params) {
	if (exists($params->{type}) && $params->{type} eq 'image') {
	    my $status = 0;	    
	    $self->{imagefile} = Astro::FITS::CFITSIO::open_file($self->{name},
								 Astro::FITS::CFITSIO::READONLY(),
								 $status);
	    if ($status) {
		confess "Unable to open image FITS file ".$self->{name}."\n";
	    }
	}
    }

    # Do something with $params then return $self:
    return $self;
}

sub DEMOLISH {
    my ($self) = @_;
    if ($self->has_image) {
	$self->{imagefile}->close_file;
    }
}

no Moose;

__PACKAGE__->meta->make_immutable();

1;
