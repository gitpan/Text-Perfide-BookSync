use 5.006;
use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Text::Perfide::BookSync',
    license             => 'perl',
    dist_author         => q{Andre Santos <andrefs@cpan.org>},
    dist_version_from   => 'lib/Text/Perfide/BookSync.pm',
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'perl' => 5.006,
		'HTML::Auto' => 0.03,
		'Cwd'       		=> 0,
		'Data::Dumper'		=> 0,
		'File::Basename'	=> 0,
		'File::Spec'		=> 0,
		'List::Util'		=> 0,
		'utf8::all' 		=> 0,
    },
    add_to_cleanup      => [ 'Text-Perfide-BookSync-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
