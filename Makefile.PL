use inc::Module::Install;
name 'XML-Feed-Deduper';
all_from 'lib/XML/Feed/Deduper.pm';

requires 'Any::Moose' => 0.06;
requires 'XML::Feed'  => 0.41;

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
