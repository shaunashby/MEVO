package VO::Service::WCS;

use Moose;
use namespace::clean -except => 'meta';

use MooseX::Types::Astro::Coords;
use MooseX::Role::Cmd::Meta::Attribute::Trait::PIL;

with 'MooseX::Role::Cmd';

# Constants for executable name and needed environments:
use constant WCS_PIXEL_PARAMS => '/Users/Shared/projects/isdcvo/dist/bin/wcs_pixel_params';
use constant PFILES           => '/Users/Shared/projects/isdcvo/dist/pfiles';

# Environment accessors for setting default environments for the command:
has 'pfiles' => (
    is          => 'ro',
    isa         => 'Str', traits => [ 'CmdOpt' ],
    cmdopt_env  => 'PFILES',
    default     => PFILES
    );

has 'commonscript' => (
    is         => 'ro',
    isa        => 'Str', traits => [ 'CmdOpt' ],
    cmdopt_env => 'COMMONSCRIPT',
    default    => 1
    );

# Attributes:
has 'Axis_RA'  => (
    is      => 'rw',
    isa     => 'RAValue', traits => [ 'CmdOptWithSeparator' ],
    lazy    => 1,
    default => sub { 266.406567 }
    );

has 'Axis_DEC' => (
    is      => 'rw',
    isa     => 'DECValue', traits => [ 'CmdOptWithSeparator' ],
    lazy    => 1,
    default => sub { -28.935839 }
    );

has 'Size_RA'  => (
    is      => 'rw',
    isa     => 'RAValue', traits => [ 'CmdOptWithSeparator' ],
    lazy    => 1,
    default => sub { 2.5 }
    );

has 'Size_DEC' => (
    is      => 'rw',
    isa     => 'DECValue', traits => [ 'CmdOptWithSeparator' ],
    lazy    => 1,
    default => sub { 2.5 }
    );

has 'Instrument'  => (
    is      => 'rw',
    isa     => 'Str', traits => [ 'CmdOptWithSeparator' ],
    lazy    => 1,
    default => sub { 'ISGRI' }
    );

has 'BaseDir' => (
    is      => 'rw', isa => 'Str', traits => [ 'CmdOptWithSeparator' ],
    lazy    => 1,
    default => sub { "/scratch/archive" }
    );

has 'Chatty' => (
    is      => 'rw',
    isa     => 'Int', traits => [ 'CmdOptWithSeparator' ],
    lazy    => 1,
    default => 0
    );

# Returns the path to the executable for our package:
sub build_bin_name() { WCS_PIXEL_PARAMS }

sub status() {
    my $self = shift;
    @_ ? $self->{status} = shift
	: $self->{status};
}

# Wrap _attr_to_cmd_options to apply our trait where the command arg is followed by a
# separator (like "=") as specified by the CmdOptWithSeparator trait:
around '_attr_to_cmd_options' => sub {
    my ($next,$self,$attr) = @_;
    my $attr_name = $attr->name;
    my $opt_name = $attr_name;
    my $opt_prefix = '';
    my $opt_separator = '';
    
    # We only do something for attributes with the PIL trait (PIL for the parameter
    # library: this package will register the CmdOptWithSeparator alias package which
    # is the name of the trait to apply in the "has" declarations for the class):
    if ($attr->does("MooseX::Role::Cmd::Meta::Attribute::Trait::PIL")) {
	$opt_name = $attr_name;
	
	if ($attr->has_cmdopt_prefix) {
            $opt_prefix = $attr->cmdopt_prefix;
        }

	if ($attr->has_cmdopt_name) {
            $opt_name = $attr->cmdopt_name;
        }
	
	if ($attr->has_cmdopt_separator) {
	    $opt_separator = $attr->cmdopt_separator;
	    $opt_name = $opt_name.$opt_separator;
	}
	
	my $opt_fullname = $opt_prefix.$opt_name;
	my @options = ();
	
	# Push the arg/value string onto the options array:
	push @options, ( $opt_fullname.$self->$attr_name );
	return wantarray ? @options : \@options;
    }
    
    # For all other arguments, return via the original method call:
    return $self->$next($attr);
};

# Override the base class run method. No need to use "around" here:
sub run() {
    my ($self, @args) = @_;
    my $cmd = $self->bin_name;
    my $full_path;
    
    if ( !( $full_path = IPC::Cmd::can_run($cmd) ) ) {
	$self->stderr([ qq{couldn't find command '$cmd'} ]);
	$self->status(255);
	return;
    }
    
    @args = $self->cmd_args( @args );

    my ( $success, $error_code, $full_buf, $stdout_buf, $stderr_buf ) =
	IPC::Cmd::run( command => [ $full_path, @args ] );
    
    if ( !$success ) {
	my ($err) = ($error_code =~ /.*?exited with value (.*?)$/); 
	$self->status($err);
	# All of the output buffers are references to arrays which contain the entire
	# buffer as a single string in the first element. Take this and split it on
	# newlines, then return a new array ref with each line appended with a newline:	
	my $outbuf = [ map { $_."\n" } split(/\n/,$full_buf->[0] ) ];
	# Write to STDERR buffer, scanning for usual ISDC error string:
	$self->stderr([ grep { $_ =~ /Error/ } @$outbuf ]);
	$self->stdout($outbuf);
    } else {
	# Turn off unitialized warnings: either that or we have to check whether in fact there
	# is contents in the out/err buffers...some programs are broken and return only STDOUT,
	# even when there are errors. Sillyness.
	{
	    no warnings 'uninitialized';
	    # Return buffers with correct newlines (corrected array contents):
	    $self->stdout([ map { $_."\n" } split(/\n/,$stdout_buf->[0] ) ]);
	    $self->stderr([ map { $_."\n" } split(/\n/,$stderr_buf->[0] ) ]);
	}
    }
}

no Moose;

__PACKAGE__->meta->make_immutable;

1;
