use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'MEVO',
    AUTHOR              => 'Shaun Ashby <Shaun.Ashby@unige.ch>',
    VERSION_FROM        => 'lib/MEVO.pm',
    ABSTRACT_FROM       => 'lib/MEVO.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
	'Path::Class::File' => 0,
	'File::ChangeNotify::Event' => 0,
	'namespace::clean'  => 0.11,
	'Moose'       => 0.93,
	'Moose::Role' => 0.93,
	'Moose::Util::TypeConstraints' => 0.93,
	'MooseX::Role::Cmd' => 0.09,
	'IPC::Cmd'    => 0.4,
	'IPC::Run'    => 0.89
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'MEVO-*' },
);
