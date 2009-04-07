use inc::Module::Install;
name 'XML-Feed-Deduped';
all_from 'lib/XML/Feed/Deduped.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
