use strict;
use warnings FATAL => 'all';
use Module::Build;

my $build = Module::Build->new(
    license              => 'perl',
    recursive_test_files => 1,
    dynamic_config       => 0,
    build_requires       => {},
    configure_requires   => { 'Module::Build' => '0.38' },
    requires             => {
        'XML::Feed'  => '0.41',
        'Any::Moose' => '0.1',
        'DB_File'    => '0',
        'perl'       => '5.8.8',
    },
    no_index    => { 'directory' => [ 'inc', 't', 'xt' ] },
    name        => 'XML-Feed-Deduper',
    module_name => 'XML::Feed::Deduper',

    test_files => ( -d '.git' || $ENV{RELEASE_TESTING} ) ? 't/ xt/' : 't/',

    create_readme  => 1,
    create_license => 1,
);
$build->create_build_script();
