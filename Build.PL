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
		'HTML::Auto' => 0,
    },
    add_to_cleanup      => [ 'Text-Perfide-BookSync-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
